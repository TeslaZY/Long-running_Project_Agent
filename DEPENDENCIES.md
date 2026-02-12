# 外部依赖说明

本文档列出 Long-Running Product Agent 的所有外部依赖。

## 快速安装

运行自动化安装脚本（推荐）：

```bash
# 进入插件目录
cd /path/to/Long-running_Product_Agent

# 运行安装脚本
./scripts/install-deps.sh
```

脚本会交互式地询问并安装所需依赖。

## 必需依赖

这些是插件运行所必需的基础工具：

| 依赖 | 版本要求 | 用途 | 安装命令 |
|------|----------|------|----------|
| Git | 2.x+ | 版本控制和会话状态管理 | 系统包管理器 |
| Claude Code | 最新版 | AI 编码助手 | [官网下载](https://claude.ai/code) |

## 可选依赖

这些依赖根据项目需求选择性安装：

### Python 项目开发

| 依赖 | 版本要求 | 用途 | 安装命令 |
|------|----------|------|----------|
| uv | 最新版 | Python 包管理器（替代 pip） | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Python | 3.11+ | Python 运行时 | 系统包管理器或 uv |

### 规格驱动开发（Spec-Kit）

| 依赖 | 版本要求 | 用途 | 安装命令 |
|------|----------|------|----------|
| specify-cli | 最新版 | Spec-Driven Development CLI | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` |

### UI/UX 开发增强

| 依赖 | 来源 | 用途 | 安装命令 |
|------|------|------|----------|
| superpowers | 插件市场 | 完整开发工作流（TDD、调试等） | `/plugin marketplace add obra/superpowers-marketplace` 然后 `/plugin install superpowers@superpowers-marketplace` |
| ui-ux-pro-max | 插件市场 | UI/UX 设计智能 | `/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill` 然后 `/plugin install ui-ux-pro-max@ui-ux-pro-max-skill` |

## 依赖检测

运行 `/init` 时会自动检测以下依赖：

```bash
# 检测 Git
git --version

# 检测 Python（可选）
python --version

# 检测 uv（可选）
uv --version

# 检测 specify-cli（可选）
specify --version
```

## 快速安装脚本

### macOS/Linux

```bash
# 安装 uv（Python 项目必需）
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool update-shell

# 安装 specify-cli（规格驱动开发）
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# 验证安装
git --version
uv --version
specify --version 2>/dev/null || echo "specify-cli not installed (optional)"
```

### Claude Code 插件安装

```bash
# 安装 superpowers（开发工作流）
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

# 安装 ui-ux-pro（UI 设计）
/plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
/plugin install ui-ux-pro-max@ui-ux-pro-max-skill
```

## 按场景选择依赖

| 场景 | 推荐依赖 |
|------|----------|
| 最小化使用 | Git + Claude Code |
| Python 后端开发 | + uv + Python 3.11+ |
| 前端开发 | + superpowers + ui-ux-pro-max |
| 规格驱动开发 | + specify-cli |
| 完整全栈开发 | 全部安装 |

## 常见问题

### Q: 不安装可选依赖能用吗？

A: 可以。核心功能（需求收集、文档生成、任务管理）不需要可选依赖。可选依赖只在特定场景下增强功能。

### Q: uv 和 pip 有什么区别？

A: uv 是用 Rust 编写的 Python 包管理器，比 pip 快 10-100 倍。本插件推荐使用 uv，但如果你更熟悉 pip 也可以使用。

### Q: superpowers 和 ui-ux-pro 必须安装吗？

A: 不必须。它们是 Claude Code 插件，提供额外的开发工作流和 UI 设计能力。如果你只需要基本的全栈开发功能，可以不安装。
