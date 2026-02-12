---
description: Show current project progress - displays task list status, phase information, and next recommended action
disable-model-invocation: true
---

# Project Progress Report

Read and display the current project status from the following sources:

## 1. Task List Status
Read `task-list.json` and display:
- Total tasks vs completed tasks
- Current phase and its status
- Tasks in progress
- Blocked tasks (dependencies not met)
- Overall completion percentage

## 2. Recent Activity
Read `agent-progress.md` and display:
- Last session summary
- Most recent tasks completed
- Any issues noted

## 3. Git Status
Show:
- Current branch
- Last 5 commits
- Uncommitted changes (if any)

## 4. Phase Breakdown
For each phase in task-list.json, show:
```
Phase X: [Name]
Status: [pending/in_progress/completed]
Progress: [X/Y tasks]
```

## 5. Next Recommended Action
Based on the current state, suggest:
- If no task-list.json exists: Run `/init` to start
- If tasks pending: Show highest priority next task
- If all complete: Suggest `/audit` or deployment

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                 PROJECT PROGRESS REPORT                       ║
╠══════════════════════════════════════════════════════════════╣
║ Project: [name]                                               ║
║ Overall: [X/Y tasks] ([Z]%)                                   ║
║ Current Phase: [phase name]                                   ║
╠══════════════════════════════════════════════════════════════╣
║ PHASE BREAKDOWN                                               ║
║ ─────────────────────────────────────────────────────────────║
║ Phase 1: Requirements        [X/Y] ████████░░ [80%]          ║
║ Phase 2: Specification       [X/Y] ████░░░░░░ [40%]          ║
║ Phase 3: Design              [X/Y] ██░░░░░░░░ [20%]          ║
║ Phase 4: Architecture        [X/Y] ░░░░░░░░░░ [0%]           ║
║ Phase 5: Frontend            [X/Y] ░░░░░░░░░░ [0%]           ║
║ Phase 6: Backend             [X/Y] ░░░░░░░░░░ [0%]           ║
║ Phase 7: Testing             [X/Y] ░░░░░░░░░░ [0%]           ║
║ Phase 8: Review              [X/Y] ░░░░░░░░░░ [0%]           ║
║ Phase 9: Deployment          [X/Y] ░░░░░░░░░░ [0%]           ║
╠══════════════════════════════════════════════════════════════╣
║ NEXT ACTION: [recommended command or task]                    ║
╚══════════════════════════════════════════════════════════════╝
```

