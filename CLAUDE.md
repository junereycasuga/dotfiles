# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive macOS dotfiles repository that manages development environment configuration using GNU Stow for symlink management. The setup includes modern development tools, window management, and productivity applications.

## Essential Commands

### Initial Setup
```bash
./install.sh                    # Full system setup (installs Homebrew, dependencies, configures symlinks)
```

### Package Management
```bash
brew bundle                     # Install/update all dependencies from Brewfile
brew bundle cleanup             # Remove packages not in Brewfile
```

### Configuration Management
```bash
stow -t ~ home                  # Apply home directory configs (~/.zshrc, etc.)
stow -t ~/.config config        # Apply XDG config directory configs
stow -R -t ~ home              # Restow (relink) home configs
stow -D -t ~ home              # Unstow (remove) home configs
```

### Shell & Environment
```bash
reloadcli                      # Reload shell configuration (alias for source ~/.zshrc)
```

### ASDF Version Management
```bash
asdf plugin-add <name> <repo>  # Add language plugin
asdf install <lang> <version>  # Install specific version
asdf global <lang> <version>   # Set global version
asdf list <lang>               # List installed versions
```

## Architecture & Structure

### Two-Tier Stow Configuration
- `home/`: Files symlinked to `~/` (mainly `.zshrc`)
- `config/`: Files symlinked to `~/.config/` (application configs)

### Key Configuration Files
- `aliases.zsh`: Shell aliases and functions (sourced by .zshrc)
- `path.zsh`: PATH configuration (sourced by .zshrc)
- `Brewfile`: Homebrew package definitions
- `install.sh`: Complete system setup script

### Application Configurations
- **Neovim**: `config/nvim/` - Lua-based configuration with lazy.nvim
- **tmux**: `config/tmux/` - Terminal multiplexer with plugin management via TPM
- **AeroSpace**: `config/aerospace/` - i3-like window manager for macOS
- **Starship**: `config/starship/` - Shell prompt configuration
- **Ghostty**: `config/ghostty/` - Terminal emulator
- **k9s**: `config/k9s/` - Kubernetes CLI with cluster configurations

### Shell Environment
- **Zsh**: Primary shell with completion system and history optimization
- **Antidote**: Plugin manager for Zsh
- **Starship**: Cross-shell prompt
- **FZF**: Fuzzy finder with custom keybindings and preview commands
- **Zoxide**: Smart directory navigation (cd replacement)
- **Atuin**: Shell history replacement

## Important Aliases

### Navigation
- `projects` → `cd ~/projects`
- `dotfiles` → `cd $DOTFILES`
- `desktop`, `downloads`, `documents` → Navigate to standard directories

### Development
- `v` → `nvim` (preferred editor)
- `ll` → `eza --long --header --git` (enhanced ls)
- `ff` → Fuzzy window finder using AeroSpace

### Git
- `gst` → `git status`
- `gsm` → `git smart-merge`
- `gsp` → `git smart-pull`

### Docker
- `d` → `docker`
- `dstop` → Stop all containers
- `dpurgecontainers` → Stop and remove all containers

## Development Environment

### Language Support
- **Go**: Managed via asdf, configured for development
- **Node.js**: Managed via asdf with npm/yarn support
- **Terraform**: Managed via asdf with tflint integration
- **Zig**: Managed via asdf for systems programming

### Key Tools
- **1Password CLI**: Integrated for secure credential management
- **AWS CLI**: For cloud development
- **Docker/OrbStack**: Container development
- **Bruno/Postman**: API testing
- **rainfrog**: Database TUI client

## tmux Configuration

### Plugin Management
Uses TPM (Tmux Plugin Manager) with plugins:
- `tmux-sensible`: Sensible defaults
- `tmux-resurrect`: Session persistence
- `tmux-continuum`: Automatic session saving
- `tmux-sessionx`: Enhanced session management
- `catppuccin-tmux`: Color theme
- `vim-tmux-navigator`: Seamless vim/tmux navigation

### Key tmux Commands
```bash
<prefix> I          # Install plugins (after adding to config)
<prefix> U          # Update plugins
<prefix> alt-u      # Uninstall plugins
```

## Neovim Configuration

### Package Management
- Uses `lazy.nvim` for plugin management
- Configuration split into modular files in `lua/` directory
- Plugins organized by category: ai, debug, editor, git, http, lsp, navigation, ui

### Key Features
- LSP integration for multiple languages
- Debug adapter protocol (DAP) support
- Git integration with advanced diff tools
- AI-powered assistance plugins
- HTTP client for API testing

## Window Management (AeroSpace)

### Key Features
- i3-like tiling window manager for macOS
- Workspace-based window organization
- Integration with tmux and terminal workflows
- Fuzzy window finder (`ff` alias)

## Notes for Development

- All shell configurations use Zsh with modern completion system
- PATH management is centralized in `path.zsh`
- Package management is declarative via Brewfile
- Configuration changes should be made in dotfiles, then re-stowed
- The setup prioritizes modern CLI tools (eza, bat, fd, ripgrep) over traditional ones