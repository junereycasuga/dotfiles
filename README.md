## Developer Mac Setup 👩🏻‍💻👨🏽‍💻👨🏻‍💻👩🏿‍💻

A comprehensive macOS dotfiles setup featuring modern development tools and configurations managed with GNU Stow and Homebrew.

## What's Included

### Core Development Tools
- **Neovim**: Lua-based configuration with modern plugins
- **tmux**: Terminal multiplexer with custom keybindings
- **Zsh**: Shell with Starship prompt and Antidote plugin manager
- **Git**: Version control with useful aliases and configurations

### Window Management & Terminal
- **AeroSpace**: i3-like tiling window manager for macOS
- **Ghostty**: Modern terminal emulator
- **Borders**: Colored window borders for enhanced visibility

### Development Environment
- **asdf**: Version manager for Node.js, Go, Terraform, and Zig
- **OrbStack**: Docker Desktop alternative
- **Homebrew**: Package manager with comprehensive tool collection

### Productivity Tools
- **1Password**: Password manager with CLI integration
- **Raycast**: Application launcher and productivity suite
- **Obsidian**: Note-taking and knowledge management
- **Bruno**: API testing client

### Command Line Utilities
- **Modern replacements**: `eza` (ls), `bat` (cat), `fd` (find), `ripgrep` (grep)
- **Navigation**: `zoxide` (cd), `fzf` (fuzzy finder)
- **Monitoring**: `htop`, `btop`, `k9s` (Kubernetes)
- **Database**: `rainfrog` (TUI database client)

### Languages & Frameworks
Pre-configured for:
- **Go**: With asdf version management
- **Node.js**: With npm/yarn support
- **Terraform**: With tflint for linting
- **Zig**: Modern systems programming language

## Installation

1. Update macOS to the latest version with the App Store
2. Install Xcode from the App Store, open it and accept the license agreement
3. Install macOS Command Line Tools by running `xcode-select --install`
4. Copy your public and private SSH keys to `~/.ssh` and make sure they're set to `600`
5. Clone this repo to `~/.dotfiles`
6. Append `/usr/local/bin/zsh` to the end of your `/etc/shells` file
7. Run `install.sh` to start the installation
8. Restart your computer to finalize the process

## Configuration Management

This setup uses **GNU Stow** for symlink management. Each tool has its own directory containing configuration files in the expected structure:

```
dotfiles/
├── nvim/           # Neovim configuration
├── tmux/           # tmux configuration  
├── zsh/            # Zsh configuration
├── git/            # Git configuration
├── aerospace/      # AeroSpace window manager
├── starship/       # Shell prompt
└── ...
```

To apply configurations:
```bash
stow nvim    # Apply Neovim config
stow tmux    # Apply tmux config
stow zsh     # Apply zsh config
```

## Aliases & Shortcuts

The configuration includes numerous aliases for productivity:

- Navigation: `projects`, `desktop`, `downloads`, `dotfiles`
- Git: `gst` (status), `gsm` (smart-merge), `gsp` (smart-pull)
- Docker: `d` (docker), `dstop` (stop all), `dpurgecontainers`
- Editor: `v` (nvim)
- Window Management: `ff` (fuzzy window finder with AeroSpace)

## Maintenance

```bash
# Update all packages
brew bundle

# Reload shell configuration
reloadcli

# Apply configuration changes
stow <tool-name>
```
