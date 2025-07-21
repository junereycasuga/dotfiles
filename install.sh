#!/bin/bash

set -e

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! "$(which brew)"; then
   echo "Setting up homebrew..."
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
echo "Updating homebrew..."
brew update --force # https://github.com/Homebrew/brew/issues/1151

# Install all our dependencies with bundle (See Brewfile)
echo "Installing dependencies..."
brew bundle

# echo "Setting up homebrew auto-update..."
mkdir -p ~/Library/LaunchAgents
brew autoupdate --start --cleanup

# Backups current .zshrc if found and is not a symlink
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo "Found existing .zshrc, backup to .zshrc.backup..."
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf "$HOME/.zshrc"

# Symlink other dirs/files using GNU Stow
stow -t ~ home
stow -t ~/.config config

# Add ASDF plugins
echo "Installing Go asdf plugin"
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git

echo "Install Zig asdf plugin"
asdf plugin-add zig https://github.com/asdf-community/asdf-zig.git

echo  "Installing Terraform asdf plugin"
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git

echo "Installing Node.js asdf plugin"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
