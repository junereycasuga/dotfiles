#!/bin/bash

set -e

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! "$(which brew)"; then
   echo "Setting up homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
echo "Updating homebrew..."
brew update --force # https://github.com/Homebrew/brew/issues/1151

# Install all our dependencies with bundle (See Brewfile)
echo "Installing dependencies..."
brew tap homebrew/bundle
brew bundle

echo "Setting up homebrew auto-update..."
mkdir -p ~/Library/LaunchAgents
brew autoupdate --start --cleanup

# Backups current .zshrc if found and is not a symlink
if [ -f $HOME/.zshrc ] && [ ! -L $HOME/.zshrc ]; then
  echo "Found existing .zshrc, backup to .zshrc.backup..."
  cp $HOME/.zshrc $HOME/.zshrc.backup
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf "$HOME/.zshrc"
ln -s "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"

# Configures ASDF tool and default versions
ln -sf "$HOME/.dotfiles/.tool-versions" "$HOME/.tool-versions"

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
git checkout -b v0.8.0

# Add ASDF plugins
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git;
asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git;
