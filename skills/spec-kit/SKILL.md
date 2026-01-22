---
name: spec-kit
description: Spec-Driven Development tool making specifications executable with multi-step refinement from specs to code. Supports constitution, specify, plan, tasks, and implement commands
---

# Spec-Driven Development

Spec-Driven Development 将软件开发的模式改变为：**规范变得可执行**，直接生成可工作的实现，而不仅仅是指导它们。

## 核心理念

Spec-Driven Development 强调以下内容：
- **意图驱动开发**——规范在"如何做"之前定义"做什么"
- **丰富的规范创建**——使用护栏和组织原则
- **多步骤细化**——而不是从提示词一次性生成代码
- **严重依赖**高级 AI 模型能力进行规范解释

## 前置条件

- 支持的 AI 编码助手（Claude Code、Cursor、Gemini CLI、GitHub Copilot 等）
- [uv](https://docs.astral.sh/uv/) 用于包管理
- Python 3.11+
- Git

## 安装

### 方式一：持久安装（推荐）

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
uv tool update-shell
specify --version
```

### 方式二：一次性使用

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

## 工作流程

### 1. 初始化项目

```bash
# 创建新项目
specify init <PROJECT_NAME>

# 在现有项目中初始化
specify init . --ai claude
specify init --here --ai claude

# 检查已安装工具
specify check
```

### 2. 建立项目原则

使用 `/speckit.constitution` 创建项目的指导原则和开发指南

```
/speckit.constitution 创建专注于代码质量、测试标准、用户体验一致性和性能要求的原则
```

输出：`.specify/memory/constitution.md`

### 3. 创建规范

使用 `/speckit.specify` 描述想要构建的内容，专注于"是什么"和"为什么"，而不是技术栈：

```
/speckit.specify 构建一个应用程序，帮助我将照片组织到不同的相册中。相册按日期分组，可以通过在主页上拖放来重新组织。
```

输出：`specs/<feature-name>/spec.md`

### 4. 澄清规范（可选）

使用 `/speckit.clarify` 澄清未充分说明的区域：

```
/speckit.clarify
```

### 5. 创建技术实施计划

使用 `/speckit.plan` 提供技术栈和架构选择：

```
/speckit.plan 应用程序使用 Vite 和最少量的库。尽可能使用纯 HTML、CSS 和 JavaScript。
```

输出：`specs/<feature-name>/plan.md`, `research.md`, `contracts/`

### 6. 分解任务

使用 `/speckit.tasks` 从实施计划创建可执行的任务列表：

```
/speckit.tasks
```

输出：`specs/<feature-name>/tasks.md` - 包含按用户故事组织的任务分解，依赖管理，并行执行标记

### 7. 执行实施

使用 `/speckit.implement` 执行所有任务：

```
/speckit.implement
```

## 可用命令

### 核心命令

| 命令 | 描述 | 输出 |
|------|------|------|
| `/speckit.constitution` | 创建/更新项目指导原则 | `.specify/memory/constitution.md` |
| `/speckit.specify` | 定义需求和用户故事 | `specs/<feature>/spec.md` |
| `/speckit.plan` | 创建技术实施计划 | `specs/<feature>/plan.md` |
| `/speckit.tasks` | 生成任务分解 | `specs/<feature>/tasks.md` |
| `/speckit.implement` | 执行任务构建功能 | 完整实现 |

### 可选命令

| 命令 | 描述 |
|------|------|
| `/speckit.clarify` | 澄清未充分说明的区域（在 `/speckit.plan` 之前推荐） |
| `/speckit.analyze` | 跨工件一致性和覆盖范围分析（在 `/speckit.tasks` 之后、`/speckit.implement` 之前运行） |
| `/speckit.checklist` | 生成质量检查列表，验证需求的完整性、清晰度和一致性 |

## Specify CLI 参数

| 参数/选项 | 描述 |
|-----------|------|
| `<project-name>` | 新项目目录名称 |
| `--ai` | AI 助手：claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, roo, codebuddy, amp, shai, q, bob, qoder |
| `--here` | 在当前目录初始化 |
| `--force` | 强制合并/覆盖 |
| `--no-git` | 跳过 git 仓库初始化 |
| `--debug` | 启用详细调试输出 |

## 环境变量

| 变量 | 描述 |
|------|------|
| `SPECIFY_FEATURE` | 为非 Git 仓库覆盖功能检测，设置为功能目录名称 |

## 项目结构

执行 `specify init` 后的典型结构：

```
.
├── CLAUDE.md
├── .specify/memory/
│   └── constitution.md
├── scripts/
│   ├── check-prerequisites.sh
│   ├── create-new-feature.sh
│   ├── setup-plan.sh
│   └── common.sh
├── specs/
│   └── <feature-name>/
│       ├── spec.md
│       ├── plan.md
│       ├── tasks.md
│       ├── research.md
│       ├── quickstart.md
│       ├── data-model.md
│       └── contracts/
└── templates/
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```
