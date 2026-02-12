---
description: Modify existing functionality (iteration mode) - requires existing Product-Spec.md
disable-model-invocation: true
---

# Modify Existing Functionality

This command modifies existing functionality in a project. It follows the Long-Running principle: **never modify completed tasks, only add new tasks for modifications.**

## Workflow

### 1. Read Existing Context
- Read `Product-Spec.md` to understand current functionality
- Read `task-list.json` to see current tasks and their states
- Read `agent-progress.md` to understand recent work
- Identify which existing functionality needs modification

### 2. Invoke Requirements Analysis
Invoke the `software-requirements-analysis` skill in **iteration mode**:
- Collect modification requirements
- Detect conflicts with existing functionality
- Understand what needs to change
- Ask clarifying questions

### 3. Update Product Documents
- Update `Product-Spec.md` with modified functionality
- Update `Product-Spec-CHANGELOG.md` with version bump and change type

### 4. Add New Tasks for Modifications

**Task ID Naming Convention:**
```
<original-task>-modify-001  (for modifications)
<original-task>-fix-001     (for bug fixes)
<original-task>-refactor-001 (for refactoring)
```

**Example - Modifying "login flow":**

If original task was `fe-002` (login implementation), add:

```json
{
  "id": "fe-002-modify-001",
  "category": "frontend",
  "description": "Modify login flow to add 2FA",
  "steps": [
    "Add 2FA option to login form",
    "Implement TOTP verification",
    "Add backup codes feature",
    "Update login API calls"
  ],
  "verification": [
    "2FA option appears in login",
    "TOTP verification works",
    "Backup codes can be generated",
    "Login flow still works without 2FA"
  ],
  "passes": false,
  "priority": "high",
  "dependencies": ["fe-002"],
  "estimated_sessions": 2,
  "artifacts": ["src/components/Login2FA.tsx"],
  "modifies": "fe-002"
}
```

### 5. Update Statistics

After adding tasks, update the statistics:
```json
"statistics": {
  "total_tasks": <old_count + new_tasks>,
  "completed_tasks": <unchanged>,
  "pending_tasks": <old_pending + new_tasks>,
  ...
}
```

### 6. Update Progress Log

Record the modification:
```markdown
### Modification: [Date]
**Modified Feature:** [feature description]
**Original Task:** [original-task-id]
**New Tasks Added:** [list of new task IDs]
**Next Step:** Run `/continue` to implement changes
```

### 7. Commit Changes

```bash
git add .
git commit -m "Modify: [feature description]

- Updated Product-Spec.md
- Added X modification tasks to task-list.json
- Modifies original task: [original-task-id]
- Task IDs: fe-002-modify-001, etc.
"
```

## Important Rules

1. **NEVER modify existing tasks** - Even if modifying functionality
2. **Reference original task** - Use `modifies` field or `dependencies`
3. **Set passes: false** for all new tasks
4. **Update statistics** - Reflect new tasks in counts
5. **Increment version** - Update Product-Spec version with change type

## Difference from /feature

| /feature | /update |
|----------|---------|
| Adds completely new functionality | Modifies existing functionality |
| Creates new feature modules | Extends/refactors existing code |
| Task ID: `*-new-*` or `*-enhance-*` | Task ID: `*-modify-*` or `*-fix-*` |
