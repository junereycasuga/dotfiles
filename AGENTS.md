# AGENTS.md

## Build/Lint/Test Commands
- **Installation**: `./install.sh` (full system setup)
- **Package Management**: `brew bundle` (install/update), `brew bundle cleanup` (remove unused)
- **Configuration**: `stow -t ~ home` (apply home configs), `stow -t ~/.config config` (apply XDG configs)
- **Shell**: `reloadcli` (reload shell configuration)
- **Linting**: `shellcheck` for shell scripts, `tflint` for Terraform files

## Code Style Guidelines
- **Shell Scripts**: Use `#!/bin/bash`, `set -e` for error handling, descriptive variable names in UPPER_CASE
- **Configuration Files**: Follow existing patterns, maintain 2-space indentation (Lua/YAML), preserve existing structure
- **Paths**: Use absolute paths in stow commands, prefer `$HOME` over `~` in scripts
- **Error Handling**: Always include error checking in shell scripts, use colored output for user feedback
- **File Organization**: Keep `home/` for `~/` symlinks, `config/` for `~/.config/` symlinks

## Repository Structure
- This is a **dotfiles repository** - configuration management only, no application code
- Uses GNU Stow for symlink management between source configs and system locations
- All changes should preserve existing configuration patterns and maintain compatibility
- Test changes by re-stowing configurations and verifying symlinks work correctly