---
description: List all tasks with their status - shows pending, in-progress, and completed tasks
disable-model-invocation: true
---

# Task List Viewer

Read `task-list.json` and display all tasks in a formatted view.

## Output Format

Display tasks grouped by phase with unified styling:

```
╔══════════════════════════════════════════════════════════════╗
║                    TASK LIST OVERVIEW                        ║
╠══════════════════════════════════════════════════════════════╣
║ Project: [name]                                              ║
║ Total: X | Completed: Y | Pending: Z | Blocked: W            ║
║ Current Phase: [phase name]                                  ║
╚══════════════════════════════════════════════════════════════╝

Phase 1: Requirements [████████░░] 80%
├── [✓] req-001: Initialize project and understand user's idea
├── [✓] req-002: Conduct deep requirement analysis
├── [✓] req-003: Generate Product-Spec.md
└── [→] req-004: Generate Product-Spec-CHANGELOG.md (IN PROGRESS)

Phase 2: Technical Specification [██░░░░░░░░] 20%
├── [ ] spec-001: Establish project constitution
├── [ ] spec-002: Transform Product-Spec into technical specs
├── [ ] spec-003: Clarify technical details
└── [ ] spec-004: Validate requirement completeness

Phase 3: UI/UX Design [░░░░░░░░░░] 0%
├── [ ] ui-001: Generate UI prototype prompts
└── [ ] ui-002: User confirms prototype designs

... (continue for all phases)

╔══════════════════════════════════════════════════════════════╗
║ LEGEND                                                       ║
╠══════════════════════════════════════════════════════════════╣
║ [✓] Completed  [→] In Progress  [!] Blocked  [ ] Pending     ║
╚══════════════════════════════════════════════════════════════╝
```

## Task Details

For detailed view, show:
- **ID**: Task identifier (e.g., req-001, fe-002)
- **Status**: ✓ completed, → in progress, ! blocked, pending
- **Priority**: critical, high, medium, low
- **Description**: Brief task description
- **Dependencies**: Which tasks must complete first
- **Artifacts**: Expected output files

## Filtering Options

If the user specifies a filter, show only matching tasks:
- `/tasks pending` - Show only pending tasks
- `/tasks completed` - Show only completed tasks
- `/tasks blocked` - Show only blocked tasks
- `/tasks phase:3` - Show only tasks in phase 3
- `/tasks category:frontend` - Show only frontend tasks

