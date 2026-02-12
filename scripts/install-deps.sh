#!/bin/bash

# Long-Running Product Agent - Dependencies Installer
# This script installs all required and optional dependencies

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     Long-Running Product Agent - Dependencies Installer       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Print status
print_status() {
    if [ "$2" = "installed" ]; then
        echo -e "${GREEN}✓${NC} $1 is installed"
    elif [ "$2" = "missing" ]; then
        echo -e "${RED}✗${NC} $1 is not installed"
    elif [ "$2" = "optional" ]; then
        echo -e "${YELLOW}○${NC} $1 is optional (not installed)"
    fi
}

# ============================================
# REQUIRED DEPENDENCIES
# ============================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "REQUIRED DEPENDENCIES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Git
if command_exists git; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    print_status "Git ($GIT_VERSION)" "installed"
else
    print_status "Git" "missing"
    echo "  Please install Git: https://git-scm.com/downloads"
    exit 1
fi

# Claude Code (check if in Claude Code environment)
if [ -n "$CLAUDE_CODE" ] || [ -d "$HOME/.claude" ]; then
    print_status "Claude Code" "installed"
else
    echo -e "${YELLOW}!${NC} Claude Code environment not detected"
    echo "  Make sure you're running this from Claude Code"
fi

# ============================================
# OPTIONAL DEPENDENCIES - Python
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "OPTIONAL DEPENDENCIES - Python Development"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# uv
if command_exists uv; then
    UV_VERSION=$(uv --version | cut -d' ' -f2)
    print_status "uv ($UV_VERSION)" "installed"
else
    print_status "uv" "optional"
    read -p "  Install uv? (recommended for Python projects) [y/N]: " install_uv
    if [ "$install_uv" = "y" ] || [ "$install_uv" = "Y" ]; then
        echo "  Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        # Update shell
        export PATH="$HOME/.cargo/bin:$PATH"
        echo -e "${GREEN}✓${NC} uv installed successfully"
    fi
fi

# Python
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    print_status "Python ($PYTHON_VERSION)" "installed"
else
    print_status "Python" "optional"
fi

# ============================================
# OPTIONAL DEPENDENCIES - Spec-Kit
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "OPTIONAL DEPENDENCIES - Spec-Driven Development"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# specify-cli
if command_exists specify; then
    SPECIFY_VERSION=$(specify --version 2>/dev/null || echo "unknown")
    print_status "specify-cli ($SPECIFY_VERSION)" "installed"
else
    print_status "specify-cli" "optional"
    if command_exists uv; then
        read -p "  Install specify-cli? (for spec-driven development) [y/N]: " install_specify
        if [ "$install_specify" = "y" ] || [ "$install_specify" = "Y" ]; then
            echo "  Installing specify-cli..."
            uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
            echo -e "${GREEN}✓${NC} specify-cli installed successfully"
        fi
    else
        echo "  (requires uv to be installed first)"
    fi
fi

# ============================================
# CLAUDE CODE PLUGINS
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CLAUDE CODE PLUGINS (Manual Installation)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "The following plugins enhance the agent's capabilities:"
echo ""

echo "1. Superpowers (Development Workflow - TDD, Debugging, Code Review)"
echo "   Commands to run in Claude Code:"
echo "   ┌─────────────────────────────────────────────────────────────┐"
echo "   │ /plugin marketplace add obra/superpowers-marketplace       │"
echo "   │ /plugin install superpowers@superpowers-marketplace        │"
echo "   └─────────────────────────────────────────────────────────────┘"
echo ""

echo "2. UI/UX Pro (UI/UX Design Intelligence)"
echo "   Commands to run in Claude Code:"
echo "   ┌─────────────────────────────────────────────────────────────┐"
echo "   │ /plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill│"
echo "   │ /plugin install ui-ux-pro-max@ui-ux-pro-max-skill          │"
echo "   └─────────────────────────────────────────────────────────────┘"
echo ""

read -p "Open plugin marketplace instructions? [y/N]: " open_marketplace
if [ "$open_marketplace" = "y" ] || [ "$open_marketplace" = "Y" ]; then
    echo ""
    echo "In Claude Code, run the following commands:"
    echo ""
    echo "For Superpowers:"
    echo "  /plugin marketplace add obra/superpowers-marketplace"
    echo "  /plugin install superpowers@superpowers-marketplace"
    echo ""
    echo "For UI/UX Pro:"
    echo "  /plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill"
    echo "  /plugin install ui-ux-pro-max@ui-ux-pro-max-skill"
fi

# ============================================
# SUMMARY
# ============================================
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    INSTALLATION SUMMARY                       ║"
echo "╠══════════════════════════════════════════════════════════════╣"

echo "║ Required:                                                     ║"
if command_exists git; then
    echo "║   ✓ Git                                                       ║"
else
    echo "║   ✗ Git (REQUIRED - please install)                           ║"
fi

echo "║                                                               ║"
echo "║ Optional:                                                     ║"
if command_exists uv; then
    echo "║   ✓ uv (Python package manager)                               ║"
else
    echo "║   ○ uv (Python package manager) - not installed               ║"
fi

if command_exists specify; then
    echo "║   ✓ specify-cli (Spec-driven development)                     ║"
else
    echo "║   ○ specify-cli (Spec-driven development) - not installed     ║"
fi

echo "║                                                               ║"
echo "║ Plugins (install manually in Claude Code):                   ║"
echo "║   ○ superpowers - Development workflow                        ║"
echo "║   ○ ui-ux-pro-max - UI/UX design                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Installation complete! Run '/init' to start a new project."
