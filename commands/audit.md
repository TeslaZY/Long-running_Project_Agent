---
description: Review implementation against product documentation - final verification before deployment
disable-model-invocation: true
---

# Audit: Implementation Verification

This command performs a comprehensive audit of the implementation against the product documentation. Run this before deployment to ensure all features are complete and working.

## Workflow

### 1. Get Bearings

```bash
pwd
cat agent-progress.md
cat task-list.json
```

### 2. Verify All Tasks Completed

Check task-list.json statistics:
```json
"statistics": {
  "total_tasks": 22,
  "completed_tasks": 22,
  "pending_tasks": 0,
  "blocked_tasks": 0
}
```

If `pending_tasks > 0`, warn user and suggest `/continue` first.

### 3. Feature Completeness Check

For each feature in `Product-Spec.md`:

```markdown
## Feature Checklist

### [Feature Name]
- [ ] Functional requirements met
- [ ] UI matches design specifications
- [ ] API endpoints working
- [ ] Error handling in place
- [ ] Edge cases handled
```

### 4. Product-Spec Compliance

Read `Product-Spec.md` and verify:

| Section | Verification |
|---------|-------------|
| Core Features | Each feature is implemented and working |
| User Personas | All user types can use the system |
| Functional Requirements | All requirements have corresponding code |
| Non-Functional Requirements | Performance, security requirements met |
| Technical Direction | Followed agreed tech stack |

### 5. Changelog Review

Read `Product-Spec-CHANGELOG.md`:
- Verify all versions are documented
- Check that all changes have corresponding tasks
- Confirm nothing was implemented without documentation

### 6. Code Quality Gates

Run the following checks:

```bash
# Frontend
npm run lint
npm run test
npm run build

# Backend (if Python)
uv run pytest
uv run ruff check .

# Backend (if Node.js)
npm run lint
npm run test
```

### 7. Integration Tests

Verify end-to-end flows work:
- User registration/login flow
- Core feature workflows
- Error scenarios
- Edge cases

### 8. Generate Audit Report

Create `audit-report.md`:

```markdown
# Audit Report

**Date:** [Date]
**Version:** [Product-Spec version]
**Auditor:** Long-Running Agent

## Summary

- Total Features: X
- Fully Implemented: Y
- Partially Implemented: Z
- Not Implemented: W

## Feature Status

| Feature | Status | Notes |
|---------|--------|-------|
| Feature 1 | ✅ Complete | All requirements met |
| Feature 2 | ⚠️ Partial | Missing edge case handling |
| Feature 3 | ❌ Missing | Not found in codebase |

## Issues Found

### Critical
- [List critical issues]

### High
- [List high priority issues]

### Medium
- [List medium priority issues]

### Low
- [List low priority issues]

## Recommendations

1. [Recommendation 1]
2. [Recommendation 2]

## Deployment Readiness

- [ ] All features implemented
- [ ] All tests passing
- [ ] No critical issues
- [ ] Documentation complete
- [ ] Performance acceptable

**Recommendation:** READY / NOT READY for deployment
```

### 9. Output Format

Display audit results:

```
╔══════════════════════════════════════════════════════════════╗
║                      AUDIT RESULTS                           ║
╠══════════════════════════════════════════════════════════════╣
║ Project: [name]                                              ║
║ Version: [version]                                           ║
║                                                              ║
║ Features: X total, Y complete, Z partial, W missing          ║
║ Tests: [pass/fail status]                                    ║
║ Build: [success/fail]                                        ║
║                                                              ║
║ Issues: Critical: X | High: Y | Medium: Z | Low: W          ║
║                                                              ║
║ Deployment: READY / NOT READY                                ║
╚══════════════════════════════════════════════════════════════╝

Detailed report saved to: audit-report.md
```

## Exit Codes

| Status | Meaning | Next Action |
|--------|---------|-------------|
| READY | All checks pass, deployment approved | Proceed to deploy |
| NOT READY | Issues found that block deployment | Fix issues, run `/audit` again |

## Important Rules

1. **Run only when all tasks complete** - Audit assumes development is done
2. **Be thorough** - Check every feature against Product-Spec
3. **Document issues** - Every issue should be actionable
4. **No auto-fix** - Report issues, don't silently fix them
5. **Human approval required** - Final deployment decision is human's
