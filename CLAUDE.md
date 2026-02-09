# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Octo.nvim is a Neovim plugin for editing and reviewing GitHub issues, pull requests, and discussions directly from your editor. It integrates with GitHub CLI (`gh`) to provide a seamless experience for GitHub operations.

## Development Commands

Use the Makefile for common development tasks:

```bash
make help    # Show all available commands
make setup   # Install development dependencies
make test    # Run all tests
make lint    # Check code style
make format  # Format code
make clean   # Remove dependencies
```

### Manual Commands (for reference)

**Linting:**
```bash
stylua --check lua/
```

**Formatting:**
```bash
stylua lua/
```

**Testing:**
```bash
nvim --headless --noplugin -u lua/tests/minimal_init.lua \
  -c "PlenaryBustedDirectory lua/tests/ {minimal_init = 'lua/tests/minimal_init.lua'}"
```

### Type Checking
Uses lua-language-server for type checking. The project uses extensive Lua type annotations (@class, @field, @param, @return).

## High-Level Architecture

### Core Components

1. **OctoBuffer** (`lua/octo/model/octo-buffer.lua`): Central abstraction representing GitHub entities (issues, PRs, discussions) as Neovim buffers. Manages state, metadata, and operations.

2. **GitHub Integration** (`lua/octo/gh/`): 
   - GraphQL queries and mutations for GitHub API
   - Fragments for reusable query components
   - `gh` CLI wrapper for authentication and API calls

3. **User Interface** (`lua/octo/ui/`):
   - **Bubbles**: Special highlighting for GitHub elements (users, reactions, labels)
   - **Signs**: Gutter indicators for comments and changes
   - **Colors**: Custom highlight groups matching GitHub's color scheme
   - **Writers**: Functions to render different parts of issues/PRs

4. **Pickers** (`lua/octo/pickers/`): Integration with multiple fuzzy finders:
   - Telescope (primary)
   - fzf-lua
   - Snacks.nvim
   - Each picker provides consistent interfaces for listing issues, PRs, etc.

5. **Reviews** (`lua/octo/reviews/`): Specialized system for PR reviews:
   - File panel showing changed files
   - Diff view with inline comments
   - Thread management for review discussions

### Key Design Patterns

- **Metadata Classes**: Separate metadata tracking for titles, bodies, comments, and threads enables precise buffer management and updates
- **Lazy Loading**: Components loaded on-demand to minimize startup time
- **Extensible Mappings**: User-configurable keybindings with sensible defaults
- **Picker Abstraction**: Single interface supporting multiple fuzzy finder backends

### File Organization

- `lua/octo/` - Main plugin code
  - `model/` - Data models and buffer abstractions
  - `ui/` - Visual components and rendering
  - `gh/` - GitHub API integration
  - `pickers/` - Fuzzy finder integrations
  - `reviews/` - PR review functionality
- `lua/tests/` - Test files using Plenary
- `after/syntax/` - Vim syntax highlighting for octo buffers
- `.github/workflows/` - CI/CD configuration

### Dependencies

- Neovim >= 0.10.0
- GitHub CLI (`gh`) - required for authentication
- plenary.nvim - required for async operations
- One of: telescope.nvim, fzf-lua, or snacks.nvim - for fuzzy finding
- nvim-web-devicons - for file icons

### Code Style

- Lua 5.2 syntax
- 120 column width
- 2 space indentation
- Double quotes preferred (via stylua)
- No parentheses for single-argument function calls
- Extensive use of Lua type annotations for documentation and type checking
