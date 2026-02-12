---
description: Add new features (iteration mode) - requires existing Product-Spec.md
disable-model-invocation: true
---

# Add New Feature

This command adds a new feature to an existing project. It follows the Long-Running principle: **never modify completed tasks, only add new tasks.**

## Workflow

### 1. Read Existing Context
- Read `Product-Spec.md` to understand current functionality
- Read `task-list.json` to see current tasks and their states
- Read `agent-progress.md` to understand recent work

### 2. Invoke Requirements Analysis
Invoke the `software-requirements-analysis` skill in **iteration mode**:
- Collect new feature requirements
- Detect conflicts with existing functionality
- Ask clarifying questions

### 3. Update Product Documents
- Update `Product-Spec.md` with new feature
- Update `Product-Spec-CHANGELOG.md` with version bump

### 4. Add New Tasks to task-list.json

**Task ID Naming Convention:**
```
<original-task>-enhance-001  (for enhancements)
<original-task>-new-001      (for new features)
<phase>-new-001              (for standalone new features)
```

**Example - Adding a new feature "user profile page":**

```json
{
  "id": "fe-new-001",
  "category": "frontend",
  "description": "Implement user profile page",
  "steps": [
    "Create profile page component",
    "Add profile editing form",
    "Implement avatar upload",
    "Connect to backend API"
  ],
  "verification": [
    "Profile page renders correctly",
    "User can edit profile",
    "Avatar upload works",
    "Changes persist to backend"
  ],
  "passes": false,
  "priority": "high",
  "dependencies": ["be-new-001"],
  "estimated_sessions": 2,
  "artifacts": ["src/pages/Profile.tsx"]
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

Record the feature addition:
```markdown
### Feature Addition: [Date]
**New Feature:** [feature description]
**Tasks Added:** [list of new task IDs]
**Next Step:** Run `/continue` to implement
```

### 7. Commit Changes

```bash
git add .
git commit -m "Add feature: [feature description]

- Updated Product-Spec.md
- Added X new tasks to task-list.json
- Task IDs: fe-new-001, be-new-001, etc.
"
```

## Important Rules

1. **NEVER modify existing tasks** - Only add new tasks
2. **Set passes: false** for all new tasks
3. **Set appropriate dependencies** - Link to related existing tasks
4. **Update statistics** - Reflect new tasks in counts
5. **Increment version** - Update Product-Spec version
