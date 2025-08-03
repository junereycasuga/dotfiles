#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display the splash screen
show_splash() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
     ██╗██╗   ██╗███╗   ██╗███████╗██████╗ ███████╗██╗   ██╗
     ██║██║   ██║████╗  ██║██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝
     ██║██║   ██║██╔██╗ ██║█████╗  ██████╔╝█████╗   ╚████╔╝ 
██   ██║██║   ██║██║╚██╗██║██╔══╝  ██╔══██╗██╔══╝    ╚██╔╝  
╚█████╔╝╚██████╔╝██║ ╚████║███████╗██║  ██║███████╗   ██║   
 ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   
                                                              
     ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
     ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
     ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
     ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
     ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
     ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
EOF
    echo -e "${NC}"
    echo
    echo -e "${PURPLE}🚀 Welcome to Junerey's macOS Development Environment Setup${NC}"
    echo -e "${YELLOW}📦 This script will configure your Mac with modern development tools${NC}"
    echo
    echo -e "${BLUE}What this setup includes:${NC}"
    echo "  • Homebrew package manager and essential tools"
    echo "  • Neovim with Lua configuration"
    echo "  • tmux with modern plugins"
    echo "  • Zsh with Starship prompt and modern CLI tools"
    echo "  • AeroSpace window manager"
    echo "  • Development languages via asdf (Go, Node.js, Terraform, Zig)"
    echo "  • Productivity applications and utilities"
    echo
    echo -e "${YELLOW}⚠️  This script will:${NC}"
    echo "  • Install/update Homebrew and packages"
    echo "  • Backup and replace your .zshrc"
    echo "  • Create symlinks for configuration files"
    echo "  • Install asdf language plugins"
    echo
}

# Function to confirm installation
confirm_installation() {
    echo -e "${GREEN}📋 Ready to proceed with the installation?${NC}"
    echo
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}❌ Installation cancelled.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Starting installation...${NC}"
    echo
}

# Show splash screen and get confirmation
show_splash
confirm_installation

# Check for Homebrew and install if we don't have it
echo -e "${BLUE}🍺 Checking for Homebrew...${NC}"
if test ! "$(which brew)"; then
   echo -e "${YELLOW}📦 Installing Homebrew...${NC}"
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   echo -e "${GREEN}✅ Homebrew installed successfully${NC}"
else
   echo -e "${GREEN}✅ Homebrew already installed${NC}"
fi

# Update Homebrew recipes
echo -e "${BLUE}🔄 Updating Homebrew...${NC}"
brew update --force # https://github.com/Homebrew/brew/issues/1151
echo -e "${GREEN}✅ Homebrew updated${NC}"

# Install all our dependencies with bundle (See Brewfile)
echo -e "${BLUE}📦 Installing dependencies from Brewfile...${NC}"
brew bundle
echo -e "${GREEN}✅ Dependencies installed${NC}"

# Setup homebrew auto-update
echo -e "${BLUE}⚙️  Setting up Homebrew auto-update...${NC}"
mkdir -p ~/Library/LaunchAgents
brew autoupdate --start --cleanup
echo -e "${GREEN}✅ Auto-update configured${NC}"

# Backups current .zshrc if found and is not a symlink
echo -e "${BLUE}🔧 Configuring shell files...${NC}"
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo -e "${YELLOW}📋 Found existing .zshrc, backing up to .zshrc.backup...${NC}"
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf "$HOME/.zshrc"

# Symlink other dirs/files using GNU Stow
echo -e "${BLUE}🔗 Creating configuration symlinks...${NC}"
stow -t ~ home
stow -t ~/.config config
echo -e "${GREEN}✅ Configuration files symlinked${NC}"

# Add ASDF plugins
echo -e "${BLUE}🌐 Installing asdf language plugins...${NC}"

echo -e "${YELLOW}  📦 Installing Go asdf plugin...${NC}"
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git 2>/dev/null || echo -e "${YELLOW}    ℹ️  Go plugin already installed${NC}"

echo -e "${YELLOW}  📦 Installing Zig asdf plugin...${NC}"
asdf plugin-add zig https://github.com/asdf-community/asdf-zig.git 2>/dev/null || echo -e "${YELLOW}    ℹ️  Zig plugin already installed${NC}"

echo -e "${YELLOW}  📦 Installing Terraform asdf plugin...${NC}"
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git 2>/dev/null || echo -e "${YELLOW}    ℹ️  Terraform plugin already installed${NC}"

echo -e "${YELLOW}  📦 Installing Node.js asdf plugin...${NC}"
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || echo -e "${YELLOW}    ℹ️  Node.js plugin already installed${NC}"

echo -e "${GREEN}✅ Language plugins configured${NC}"

echo
echo -e "${PURPLE}🎉 Installation completed successfully!${NC}"
echo
echo -e "${CYAN}📝 Next steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Install language versions with asdf (e.g., asdf install golang latest)"
echo "  3. Configure your applications as needed"
echo
echo -e "${GREEN}🚀 Happy coding!${NC}"
