---
name: session-manager
description: Manages long-running agent sessions across multiple context windows. Handles session initialization, progress tracking, task state management, and session handoff.
---

# Session Manager

The Session Manager skill provides the infrastructure for long-running agents to work effectively across multiple context windows.

## Core Concepts

### Problem Statement
AI agents work in discrete sessions, and each new session begins with no memory of what came before. Complex projects cannot be completed within a single context window, so agents need a way to bridge the gap between sessions.

### Solution: Three Pillars

1. **Task List (`task-list.json`)** - The single source of truth for what needs to be built
2. **Progress Log (`agent-progress.md`)** - Human-readable session summaries
3. **Git History** - Machine-readable change history

## Task List Management

### Schema Overview

```json
{
  "project_info": {
    "name": "string",
    "description": "string",
    "created_at": "ISO timestamp",
    "last_updated": "ISO timestamp",
    "tech_stack": {}
  },
  "statistics": {
    "total_tasks": "number",
    "completed_tasks": "number",
    "in_progress_tasks": "number",
    "pending_tasks": "number",
    "blocked_tasks": "number"
  },
  "phases": [
    {
      "id": "phase-N",
      "name": "string",
      "description": "string",
      "status": "pending|in_progress|completed",
      "tasks": []
    }
  ]
}
```

### Task Schema

```json
{
  "id": "unique-task-id",
  "category": "requirements|specification|design|architecture|frontend|backend|testing|review|deployment",
  "description": "Human-readable task description",
  "steps": ["Step 1", "Step 2", "..."],
  "verification": ["Verify 1", "Verify 2", "..."],
  "passes": false,
  "priority": "critical|high|medium|low",
  "dependencies": ["task-id-1", "task-id-2"],
  "estimated_sessions": 1,
  "artifacts": ["file1.md", "file2.py"]
}
```

### Immutable Task Principle

**CRITICAL:** Once tasks are defined, they can ONLY be modified by:
- Changing `passes` from `false` to `true`
- Updating `status` in phase headers

**Never:**
- Remove tasks
- Edit task descriptions
- Modify verification steps
- Change priorities

This ensures no functionality is accidentally dropped.

## Phase Status Transitions

Phase status automatically transitions based on task completion:

### Transition Rules

```
pending ──→ in_progress ──→ completed
   │            │               │
   │            │               └── All tasks in phase have passes: true
   │            │
   │            └── First task in phase starts (first task with passes: false and dependencies met)
   │
   └── Default state for new phases
```

### Detailed Logic

| Current Status | Condition | New Status |
|----------------|-----------|------------|
| `pending` | Any task in phase has `passes: true` OR first task starts | `in_progress` |
| `in_progress` | ALL tasks in phase have `passes: true` | `completed` |
| `in_progress` | Any task has `passes: false` | `in_progress` (no change) |
| `completed` | (never changes back) | `completed` |

### Implementation

When updating task status, always recalculate phase status:

```bash
# Pseudocode for phase status update
for each phase in phases:
    tasks = phase.tasks
    completed_count = count(tasks where passes == true)
    total_count = count(tasks)

    if completed_count == total_count and total_count > 0:
        phase.status = "completed"
    elif completed_count > 0 or has_task_in_progress(phase):
        phase.status = "in_progress"
    else:
        phase.status = "pending"
```

### Update Sequence

When marking a task as complete:

1. **Update task:** Set `passes: true`
2. **Update phase status:** Check if phase should transition
3. **Recalculate statistics:** Update counts in `statistics` section
4. **Update timestamp:** Set `last_updated` to current time
5. **Commit:** Record the change in git

### Verification

After each status update, verify:

```bash
# Check phase status matches task states
cat task-list.json | jq '.phases[] | {name, status, completed: [.tasks[] | select(.passes == true)] | length, total: [.tasks] | length}'
```

## Session Workflow

### Initializer Session (First Run)

```
1. Check project state (0-1 vs iteration mode)
2. Create task-list.json from template
3. Create agent-progress.md
4. Initialize git (if needed)
5. Begin first phase tasks
6. Commit initial setup
```

### Coding Session (Subsequent Runs)

```
1. GET BEARINGS
   - Read agent-progress.md
   - Read task-list.json
   - Check git log

2. VERIFY PREVIOUS WORK
   - Test tasks marked as passing
   - Fix any regressions

3. CHOOSE NEXT TASK
   - Find highest-priority task with passes: false
   - Check dependencies are satisfied

4. IMPLEMENT
   - Follow task steps
   - Use appropriate skills
   - Test thoroughly

5. VERIFY
   - Run verification steps
   - Ensure end-to-end functionality

6. UPDATE STATE
   - Mark task as passing
   - Update statistics
   - Update progress log
   - Commit changes
```

### Session Handoff

When ending a session, always:

1. **Commit all work** - No uncommitted changes
2. **Update progress log** - Summary of what was done
3. **Update task list** - Mark completed tasks
4. **Clean state** - Project should be runnable

## Progress Log Format

```markdown
### Session N: [Date]
**Type:** Initializer|Coding

**Completed Tasks:**
- [task-id]: [brief description]

**Current Phase:** [phase name]
**Progress:** X/Y tasks completed (Z%)

**Issues Encountered:**
- [Issue and resolution]

**Next Task:**
- [task-id]: [description]

**Git Commits:**
- [hash]: [message]
```

## Task Categories and Skills

| Category | Primary Skill | Tools |
|----------|---------------|-------|
| requirements | software-requirements-analysis | User interview, documentation |
| specification | spec-kit | constitution, specify, clarify |
| design | ui-prompt-generator | UI prompts, prototypes |
| architecture | spec-kit, superpowers:brainstorming | plan, tasks, analyze |
| frontend | ui-ux-pro, superpowers:tdd | TDD, component dev |
| backend | superpowers:tdd | TDD, API dev |
| testing | superpowers:verification | Unit tests, E2E tests |
| review | superpowers:code-review | Code review |
| deployment | superpowers | Build, deploy |

## Utility Functions

### Get Task Statistics

```bash
# Count total tasks
cat task-list.json | jq '[.phases[].tasks] | flatten | length'

# Count completed tasks
cat task-list.json | jq '[.phases[].tasks] | flatten | map(select(.passes == true)) | length'

# Count remaining tasks
cat task-list.json | jq '[.phases[].tasks] | flatten | map(select(.passes == false)) | length'
```

### Find Next Task

```bash
# Find highest priority incomplete task
cat task-list.json | jq '[.phases[].tasks] | flatten | map(select(.passes == false)) | sort_by(.priority) | .[0]'
```

### Update Task Status

When marking a task as complete:
1. Find task by ID
2. Change `passes` to `true`
3. Recalculate statistics
4. Update `last_updated` timestamp

## Quality Gates

### Before Marking Task Complete

- [ ] All steps executed
- [ ] All verification steps passed
- [ ] No console errors
- [ ] Code committed
- [ ] Progress log updated

### Before Ending Session

- [ ] All changes committed
- [ ] Progress log updated
- [ ] Task list synchronized
- [ ] Project in runnable state

## Session Handoff Verification

### Pre-Handoff Checklist

Before ending a session, verify:

```bash
# 1. Check for uncommitted changes
git status --porcelain
# Should return empty

# 2. Verify task-list.json is valid JSON
cat task-list.json | jq . > /dev/null && echo "Valid JSON" || echo "Invalid JSON"

# 3. Verify statistics match actual task states
cat task-list.json | jq '{
  claimed: .statistics,
  actual: {
    total_tasks: [.phases[].tasks] | flatten | length,
    completed_tasks: [.phases[].tasks] | flatten | map(select(.passes == true)) | length,
    pending_tasks: [.phases[].tasks] | flatten | map(select(.passes == false)) | length
  }
}'

# 4. Check last session entry in progress log
tail -20 agent-progress.md | grep -A5 "Session"

# 5. Verify project runs (depends on project type)
# npm run dev, python main.py, etc.
```

### State Validation

Validate that statistics match reality:

```bash
# Compare claimed vs actual statistics
cat task-list.json | jq '
  {
    total_mismatch: (.statistics.total_tasks != ([.phases[].tasks] | flatten | length)),
    completed_mismatch: (.statistics.completed_tasks != ([.phases[].tasks] | flatten | map(select(.passes == true)) | length)),
    pending_mismatch: (.statistics.pending_tasks != ([.phases[].tasks] | flatten | map(select(.passes == false)) | length))
  }
'
```

### Automatic State Repair

If validation fails, repair the statistics:

```bash
# Repair statistics to match actual task states
total=$(cat task-list.json | jq '[.phases[].tasks] | flatten | length')
completed=$(cat task-list.json | jq '[.phases[].tasks] | flatten | map(select(.passes == true)) | length')
pending=$(cat task-list.json | jq '[.phases[].tasks] | flatten | map(select(.passes == false)) | length')

cat task-list.json | jq --argjson t "$total" --argjson c "$completed" --argjson p "$pending" '
  .statistics.total_tasks = $t |
  .statistics.completed_tasks = $c |
  .statistics.pending_tasks = $p |
  .statistics.in_progress_tasks = 0 |
  .statistics.blocked_tasks = 0
' > task-list.json.tmp && mv task-list.json.tmp task-list.json
```

## Error Recovery

### If Session Left Dirty State

1. Check git status for uncommitted changes
2. Review changes for completeness
3. Either commit or revert as appropriate
4. Update progress log to reflect reality

### If Task Was Incorrectly Marked Complete

1. Mark task as `passes: false`
2. Document why in progress log
3. Re-implement if necessary

### If Dependencies Block Progress

1. Document blocker in progress log
2. Find alternative work that isn't blocked
3. Or work on unblocking the dependency

## Best Practices

1. **One task per session** - Focus on quality over quantity
2. **Verify before marking complete** - Evidence over assertions
3. **Leave clean state** - Next session should be able to start immediately
4. **Document thoroughly** - Progress log is the memory between sessions
5. **Test end-to-end** - Not just unit tests

