# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Project Overview

**Long-Running Product Fullstack Agent** 是一个全栈开发 Agent 插件，基于 Anthropic 的 [Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) 方法论，让 AI 能够跨多个上下文窗口稳定运行，完成从需求调研、功能设计、技术方案制定、编码实现、测试交付的完整软件开发流程。

**核心理念：** 用户只需说出产品想法，剩下的需求追问、文档生成、原型设计、代码开发就自动完成。

**Long-Running 模式：** 每个会话都能从上一个会话继续工作，通过结构化任务列表和进度文件保持连续性。

## Plugin Architecture

```
Long-running_Product_Agent/
├── CLAUDE.md                          # 主控文件（本文件）
├── README.md                           # 项目说明文档
├── .claude-plugin/                     # 插件元数据
│   ├── marketplace.json
│   └── plugin.json
├── agents/
│   └── product_manager.md             # Long-Running Agent 定义
├── prompts/
│   ├── initializer-prompt.md          # 首次会话提示词
│   └── coding-agent-prompt.md         # 后续会话提示词
├── templates/
│   ├── task-list-template.json        # 任务列表模板
│   └── agent-progress-template.md     # 进度日志模板
├── commands/                           # 用户命令（7个）
│   ├── init.md                        # 初始化项目
│   ├── continue.md                    # 继续工作（核心命令）
│   ├── progress.md                    # 查看进度
│   ├── tasks.md                       # 列出所有任务
│   ├── feature.md                     # 添加新功能
│   ├── update.md                      # 修改功能
│   └── audit.md                       # 验收检查
└── skills/                             # 技能定义
    ├── session-manager/               # 会话管理技能
    │   └── SKILL.md
    ├── software-requirements-analysis/
    │   ├── SKILL.md
    │   └── assets/
    ├── ui-prompt-generator/
    │   ├── SKILL.md
    │   └── assets/
    ├── ui-ux-pro/
    │   └── SKILL.md
    ├── spec-kit/
    │   └── SKILL.md
    ├── superpowers/
    │   └── SKILL.md
    └── uv-skill/
        ├── SKILL.md
        └── references/
```

## Long-Running 工作模式

系统启动时自动检测项目状态，进入对应模式：

| 模式 | 检测条件 | 行为 |
|------|----------|------|
| **0-1 模式** | `task-list.json` 不存在 | 初始化项目，创建任务列表 |
| **继续模式** | `task-list.json` 存在，有未完成任务 | 继续下一个任务 |
| **迭代模式** | `Product-Spec.md` 存在 + 新请求 | 添加/修改功能 |
| **完成模式** | 所有任务已完成 | 部署交付 |

## 可用命令（精简版）

**只有 7 个命令：**

| 命令 | 描述 | 使用时机 |
|------|------|----------|
| `/init` | 初始化新的长期运行项目 | 开始新项目 |
| `/continue` | **核心命令** - 继续执行下一任务 | 每个后续会话 |
| `/progress` | 查看当前项目进度 | 了解状态 |
| `/tasks` | 列出所有任务和状态 | 查看任务列表 |
| `/feature <描述>` | 添加新功能（会添加新任务到列表） | 迭代模式 |
| `/update <描述>` | 修改现有功能（会添加新任务到列表） | 迭代模式 |
| `/audit` | 对照产品文档检查功能完整性 | 部署前验收 |

**设计理念：** 用户不需要知道当前在哪个阶段（UI、开发、测试等），只需要 `/continue` 让 Agent 自动执行下一任务。

**关于修改已完成任务：** 遵循 Long-Running 原则，不直接修改/重做已完成任务。如需修改，使用 `/feature` 或 `/update` 添加新任务到列表。

## 会话协议（每个会话必须遵循）

```
1. 获取方位（必须）
   - pwd
   - 读取 agent-progress.md
   - 读取 task-list.json
   - 检查 git log --oneline -10

2. 验证状态
   - 确保没有未提交的更改
   - 验证标记为通过的任务仍然正常工作
   - 检查阻塞问题

3. 选择下一个任务
   - 找到优先级最高的未完成任务 (passes: false)
   - 验证依赖已满足

4. 实现任务
   - 按任务步骤执行
   - 使用适当的技能（自动选择）
   - 充分测试

5. 验证并完成
   - 运行验证步骤
   - 标记任务为 passes: true
   - 更新统计信息

6. 交接
   - 提交更改
   - 更新 agent-progress.md
   - 确保干净状态
```

## 工作流程

### 0-1 模式（新建项目）

```bash
# 1. 初始化项目（首次会话）
/init

# 2. 后续每个会话只需
/continue

# 3. 随时查看进度或任务列表
/progress
/tasks

# 4. 部署前验收
/audit
```

### 迭代模式（修改现有项目）

```bash
# 1. 添加/修改功能（会自动添加新任务）
/feature 添加用户个人资料页面
# 或
/update 修改登录流程

# 2. 继续开发
/continue

# 3. 验收
/audit
```

## 任务自动执行流程

`/continue` 会根据 `task-list.json` 自动执行对应阶段的任务：

| 阶段 | 任务 ID | 自动调用的技能 |
|------|---------|---------------|
| 1. 需求收集 | req-001~004 | software-requirements-analysis |
| 2. 技术规格 | spec-001~004 | spec-kit |
| 3. UI/UX 设计 | ui-001~002 | ui-prompt-generator |
| 4. 架构规划 | arch-001~004 | spec-kit, superpowers:brainstorming |
| 5. 前端开发 | fe-001+ | ui-ux-pro, superpowers:tdd |
| 6. 后端开发 | be-001+ | superpowers:tdd |
| 7. 测试验证 | test-001+ | superpowers:verification |
| 8. 代码审查 | review-001+ | superpowers:code-review |
| 9. 部署交付 | deploy-001~002 | superpowers |

## 任务列表结构

`task-list.json` 是唯一的真实来源：

```json
{
  "project_info": { "name", "description", "tech_stack" },
  "statistics": { "total_tasks", "completed_tasks", ... },
  "phases": [
    {
      "id": "phase-N",
      "name": "阶段名称",
      "status": "pending|in_progress|completed",
      "tasks": [
        {
          "id": "task-XXX",
          "category": "requirements|specification|...",
          "description": "要做什么",
          "steps": ["步骤1", "步骤2"],
          "verification": ["验证1", "验证2"],
          "passes": false,
          "priority": "critical|high|medium|low",
          "dependencies": ["task-YYY"],
          "estimated_sessions": 1,
          "artifacts": ["输出文件.md"]
        }
      ]
    }
  ]
}
```

**关键规则：**
- 任务只能将 `passes` 从 `false` 改为 `true`
- 永远不要删除或修改任务定义
- 这确保没有功能被意外遗漏

## 子技能说明

| 技能 | 触发条件 | 输出 | 用途 |
|------|----------|------|------|
| `session-manager` | 自动 | task-list.json, agent-progress.md | Long-Running 会话管理 |
| `software-requirements-analysis` | `/init`, `/feature`, `/update` | Product-Spec.md | 需求收集 |
| `ui-prompt-generator` | 自动（阶段3任务） | UI-Prompts.md | UI 原型提示词 |
| `ui-ux-pro` | 自动（阶段5任务） | 前端代码 | 前端开发 |
| `spec-kit` | 自动（阶段2,4任务） | specs/, contracts/ | 规格驱动开发 |
| `superpowers` | 自动（各阶段任务） | 计划、代码、测试 | 开发工作流 |
| `uv-skill` | Python 操作 | pyproject.toml | Python 依赖管理 |

## 质量门禁

### 标记任务完成前
- [ ] 所有步骤已执行
- [ ] 所有验证步骤已通过
- [ ] 产物已按要求创建
- [ ] 没有控制台错误
- [ ] 代码已提交

### 结束会话前
- [ ] 所有更改已提交
- [ ] 进度日志已更新
- [ ] 任务列表已同步
- [ ] 项目处于可运行状态

## 关键原则

1. **先获取方位** - 任何工作前先读取进度和任务文件
2. **每会话一个任务** - 专注完美完成一个任务
3. **验证后标记完成** - 证据优于声明
4. **保持干净状态** - 下一个会话应能立即开始
5. **记录一切** - 进度日志是会话间的记忆
6. **永不修改/删除任务** - 只标记为通过
7. **文档驱动** - 写代码前先更新文档
8. **uv 管理** - Python 项目必须使用 uv，禁止使用 pip

## Long-Running Agents 研究要点

1. **Initializer + Coding Agent 模式** - 首次会话与后续会话使用不同提示词
2. **任务列表作为真实来源** - JSON 格式防止不当修改
3. **增量进展** - 一次一个功能/任务
4. **验证测试** - 始终验证之前的工作仍然正常
5. **干净状态交接** - 每个会话以可提交、可工作的代码结束

## 参考资料

### 核心方法论
- [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Claude Quickstarts: Autonomous Coding](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)

### 集成技能
- [ui-ux-pro](https://github.com/nickg/ui-ux-pro) - UI/UX 智能设计技能
- [superpowers](https://github.com/obra/superpowers) - 完整的软件开发工作流技能

