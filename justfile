set dotenv-load := false

# List available commands
default:
    just --list

# Run the full dotfiles health check
doctor:
    ./scripts/doctor.sh

# Run all non-mutating config checks
check: shell-check opencode-check brew-check stow-check

# Validate shell files and lint shell scripts
shell-check:
    zsh -n home/.zprofile home/.zshrc aliases.zsh path.zsh
    shellcheck install.sh scripts/doctor.sh

# Validate resolved opencode configuration
opencode-check:
    opencode debug config >/dev/null

# Check Brewfile dependencies without requiring upgrades
brew-check:
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --verbose --file Brewfile

# Check Brewfile dependencies including outdated packages
brew-outdated:
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --verbose --file Brewfile

# Simulate stow symlinks without modifying files
stow-check:
    mkdir -p "$HOME/.config"
    stow --no --restow -d . -t "$HOME" home
    stow --no --restow -d . -t "$HOME/.config" config

# Recreate dotfile symlinks with GNU Stow
restow:
    mkdir -p "$HOME/.config"
    stow --restow -d . -t "$HOME" home
    stow --restow -d . -t "$HOME/.config" config

# Run the interactive macOS bootstrap installer
install:
    ./install.sh

# Install missing Brewfile dependencies
brew-sync:
    brew bundle --file Brewfile

# Measure interactive zsh startup time three times
shell-time:
    for i in 1 2 3; do /usr/bin/time -p zsh -i -c exit; done

# Profile zsh startup with zprof
shell-profile:
    zsh -df -c 'zmodload zsh/zprof; source ./home/.zshrc >/dev/null 2>&1; zprof'

# Run Neovim health checks headlessly
nvim-check:
    nvim --headless '+checkhealth' '+qall'
