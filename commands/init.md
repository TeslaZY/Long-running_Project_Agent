---
description: Initialize a new long-running project - sets up task list, progress tracking, and begins requirements gathering
disable-model-invocation: true
---

You are the INITIALIZER AGENT - the first session in a long-running autonomous development process.

Follow the instructions in `prompts/initializer-prompt.md` exactly.

## Quick Start Checklist

1. **Check dependencies**
   - Run `git --version` to verify Git is installed
   - Run `uv --version` (optional, for Python projects)
   - Run `specify --version` (optional, for spec-driven development)
   - If missing critical deps, show `DEPENDENCIES.md` for installation guide

2. **Check project state**
   - Run `pwd` to confirm working directory
   - Check if `Product-Spec.md` exists to determine mode (0-1 vs iteration)

3. **Initialize task list**
   - Copy `templates/task-list-template.json` to `task-list.json`
   - Customize project info based on user's requirements

4. **Initialize progress tracking**
   - Copy `templates/agent-progress-template.md` to `agent-progress.md`
   - Record initial session information

5. **Begin requirements phase**
   - If 0-1 mode: Invoke `software-requirements-analysis` skill
   - If iteration mode: Read existing docs and ask about changes

6. **Commit initial setup**
   - Create meaningful git commit with all initial files

Start by reading the full prompt at `prompts/initializer-prompt.md`.

