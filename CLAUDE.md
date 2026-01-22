# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Project Overview

Product Fullstack Agent 是一个全栈开发 Agent 插件，集成了产品经理、UI 设计、全栈开发三种角色对应的 skill，让 AI 按照专业标准执行从需求调研、PRD 文档、功能规范、UI/UX 设计、实现架构/方案设计、编码实现、测试、部署上线到迭代的软件开发全流程。

**核心理念：** 用户只需说出产品想法，剩下的需求追问、文档生成、原型设计、代码开发就自动完成。

## Plugin Architecture

```
product-manager-agent/
├── CLAUDE.md                          # 主控文件（本文件）
├── README.md                           # 项目说明文档
├── .claude-plugin/                     # 插件元数据
│   ├── marketplace.json
│   └── plugin.json
├── commands/                           # 用户可调用命令
│   ├── new.md
│   ├── start.md
│   ├── ui.md
│   ├── design.md
│   ├── plan.md
│   ├── develop.md
│   ├── verify.md
│   ├── feature.md
│   ├── update.md
│   ├── audit.md
│   └── progress.md
├── skills/                             # 技能定义
│   ├── software-requirements-analysis/
│   │   ├── SKILL.md
│   │   └── assets/
│   │       ├── changelog-template.md
│   │       └── software-requirements-template.md
│   ├── ui-prompt-generator/
│   │   ├── SKILL.md
│   │   └── assets/
│   │       └── ui-prompt-template.md
│   ├── ui-ux-pro/
│   │   └── SKILL.md
│   ├── spec-kit/
│   │   └── SKILL.md
│   ├── superpowers/
│   │   └── SKILL.md
│   └── uv-skill/
│       ├── SKILL.md
│       └── references/
│           └── REFERENCES.md
└── agents/                             # 子代理定义
    └── product_manager.md                # Product Manager Agent 主控逻辑
```

## 工作模式

系统启动时自动检测项目状态，进入对应模式：

| 状态 | 检测条件 | 行为 |
|------|----------|------|
| **0-1 模式** | `Product-Spec.md` 不存在 | 从头开始收集需求 |
| **迭代模式** | `Product-Spec.md` 存在 | 修改/新增功能 |

## 可用命令

| 命令 | 描述 |
|--------|------|
| `/new` 或 `/start` | 开始新项目（0-1 模式） |
| `/progress` | 查看当前项目进度 |
| `/ui` | 生成 UI 原型提示词 |
| `/design` | 开始 UI/UX 设计开发 |
| `/plan` | 创建技术实现方案 |
| `/develop` | 开始代码开发实现 |
| `/verify` | 运行测试验证功能 |
| `/feature <描述>` | 添加新功能（迭代模式） |
| `/update <描述>` | 修改现有功能（迭代模式） |
| `/audit` | 对照产品文档检查功能完整性 |

## 完整工作流程

### 0-1 模式（新建项目）

```
1. 用户: /new 或说出想法
2. 调用 software-requirements-analysis（需求收集）
3. 生成 Product-Spec.md 和 Product-Spec-CHANGELOG.md
4. 调用 /speckit.constitution（建立项目原则）
5. 调用 /speckit.specify（生成技术规范）
6. 调用 /speckit.clarify（澄清技术细节）
7. 调用 /speckit.checklist（验证需求完整性）
8. 用户: /ui
9. 调用 ui-prompt-generator（生成 UI 提示词）
10. 用户确认原型图（外部工具生成）
11. 用户: /plan
12. 调用 /speckit.plan（技术实施计划）
13. 调用 /speckit.tasks（任务分解）
14. 调用 /speckit.analyze（一致性分析）
15. 调用 superpowers:brainstorming（设计细化）
16. 用户: /design
17. 调用 ui-ux-pro（前端开发）
18. 用户: /develop
19. 调用 superpowers:test-driven-development（后端开发）
20. 调用 superpowers:requesting-code-review（代码审查）
21. 调用 superpowers:executing-plans（批量执行）
22. 用户: /verify
23. 调用 superpowers:verification-before-completion（测试验证）
24. 部署上线
```

### 迭代模式（修改现有项目）

```
1. 用户: /feature <描述> 或 /update <描述>
2. 调用 software-requirements-analysis（迭代模式 - 需求更新）
3. 调用 /speckit.specify（新功能技术规范）
4. 调用 /speckit.clarify（集成细节澄清）
5. 调用 /speckit.checklist（需求完整性验证）
6. 调用 /speckit.plan（技术实施计划）
7. 调用 /speckit.tasks（任务分解）
8. 调用 superpowers:brainstorming（设计细化）
9. 用户: /develop
10. 调用 superpowers:test-driven-development（实现变更）
11. 调用 superpowers:requesting-code-review（代码审查）
12. 调用 superpowers:executing-plans（批量执行）
13. 用户: /verify
14. 调用 superpowers:verification-before-completion（运行测试）
15. 用户: /audit（验收检查）
```

## 子技能说明

| 技能 | 触发命令/技能 | 输出 |
|------|---------------|------|
| `software-requirements-analysis` | `/new`, `/feature`, `/update` | `Product-Spec.md`, `Product-Spec-CHANGELOG.md` |
| `ui-prompt-generator` | `/ui` | `UI-Prompts.md` |
| `ui-ux-pro` | `/design` | 前端代码项目 |
| `spec-kit` | `/speckit.constitution`, `/speckit.specify`, `/speckit.clarify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.analyze`, `/speckit.checklist` | `.specify/memory/constitution.md`, `specs/<feature>/spec.md`, `specs/<feature>/plan.md`, `specs/<feature>/tasks.md`, `research.md`, `contracts/` |
| `superpowers` | `brainstorming`, `writing-plans`, `test-driven-development`, `systematic-debugging`, `requesting-code-review`, `executing-plans`, `verification-before-completion` | 设计文档、开发计划、测试代码、实现代码 |
| `uv-skill` | Python 操作时自动使用 | `pyproject.toml`, `uv.lock`, `.venv/` |

## 注意事项

1. **文档驱动优先**: 所有修改必须同步到文档
2. **质量优先**: 宁可多问一轮，也别留下模糊需求
3. **用户视角**: 每问一个问题，都从用户角度想一遍
4. **技术友好**: 描述功能时，用开发能理解的术语
5. **Human-in-Loop**: 不确定的地方一定要询问用户
6. **uv 管理**: Python 项目必须使用 uv，禁止使用 pip
