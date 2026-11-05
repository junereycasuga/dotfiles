#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${RED}❌ Required command not found: $1${NC}"
        exit 1
    fi
}

load_homebrew_shellenv() {
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

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
    echo "  • Development languages via mise (Go, Node.js, Terraform, Zig)"
    echo "  • Productivity applications and utilities"
    echo
    echo -e "${YELLOW}⚠️  This script will:${NC}"
    echo "  • Install/update Homebrew and packages"
    echo "  • Backup conflicting dotfiles (~/.gitconfig, ~/.zshrc, ~/.config/*)"
    echo "  • Create symlinks for configuration files"
    echo "  • Install language versions with mise"
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
if ! command -v brew >/dev/null 2>&1; then
   echo -e "${YELLOW}📦 Installing Homebrew...${NC}"
   echo -e "${YELLOW}    Homebrew's official installer will be downloaded over HTTPS and executed.${NC}"
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   load_homebrew_shellenv
   echo -e "${GREEN}✅ Homebrew installed successfully${NC}"
else
   echo -e "${GREEN}✅ Homebrew already installed${NC}"
fi

require_command brew

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

# Portable readlink -f (macOS lacks it): resolve a path through symlinks
resolve_path() {
    local path="$1" dir
    while [[ -L "$path" ]]; do
        dir="$(cd -P "$(dirname "$path")" >/dev/null 2>&1 && pwd)"
        [[ -z "$dir" ]] && { echo "$path"; return; }  # unresolvable: return as-is
        path="$(readlink "$path")"
        [[ "$path" != /* ]] && path="$dir/$path"
    done
    dir="$(cd -P "$(dirname "$path")" >/dev/null 2>&1 && pwd)"
    [[ -z "$dir" ]] && { echo "$path"; return; }
    echo "$dir/$(basename "$path")"
}

# Back up existing targets that would conflict with stow (real files, stray
# symlinks, unexpected directories) so stow never aborts. Targets already
# owned by stow from a previous run are left alone.
prepare_package() {
    local pkg_dir="$1" target_root="$2"
    local pkg_file rel target resolved_pkg
    while IFS= read -r pkg_file; do
        rel="${pkg_file#"$pkg_dir"/}"
        [[ "$rel" == "$pkg_file" ]] && continue  # the package root itself
        target="$target_root/$rel"
        resolved_pkg="$(resolve_path "$pkg_file")"

        if [[ -d "$pkg_file" && ! -L "$pkg_file" ]]; then
            if [[ ! -e "$target" && ! -L "$target" ]]; then
                continue  # stow will create it
            elif [[ -d "$target" && ! -L "$target" ]]; then
                continue  # real dir: stow links files inside it
            elif [[ -L "$target" ]] && [[ "$(resolve_path "$target")" == "$resolved_pkg" ]]; then
                continue  # stow-owned from a previous run
            fi
            echo -e "${RED}❌ $target exists and is not managed by this dotfiles repo — move it away before continuing.${NC}"
            exit 1
        fi

        # Skip files reachable through a stow-owned directory symlink
        # (re-run: the "target" lives in the repo itself)
        if [[ -L "${target%/*}" ]] \
            && [[ "$(resolve_path "${target%/*}")" == "$(resolve_path "${pkg_file%/*}")" ]]; then
            continue
        fi

        if [[ -L "$target" ]]; then
            if [[ "$(resolve_path "$target")" == "$resolved_pkg" ]]; then
                continue  # stow-owned link from a previous run
            fi
            echo -e "${YELLOW}📋 Found existing symlink $target, backing up to $target.backup...${NC}"
            mv "$target" "$target.backup"
        elif [[ -f "$target" ]]; then
            echo -e "${YELLOW}📋 Found existing $target, backing up to $target.backup...${NC}"
            cp "$target" "$target.backup"
            rm "$target"
        elif [[ -e "$target" ]]; then
            echo -e "${RED}❌ $target exists and is not a file or symlink. Move it before continuing.${NC}"
            exit 1
        fi
    done < <(find "$pkg_dir" \( -type d -o -type f -o -type l \) | sort)
}

# Back up conflicting dotfiles from both stow packages before linking
echo -e "${BLUE}🔧 Configuring shell files...${NC}"
prepare_package home "$HOME"
prepare_package config "$HOME/.config"

# Symlink other dirs/files using GNU Stow
echo -e "${BLUE}🔗 Creating configuration symlinks...${NC}"
require_command stow
mkdir -p "$HOME/.config"
stow --restow -t ~ home
stow --restow -t ~/.config config
echo -e "${GREEN}✅ Configuration files symlinked${NC}"

# Install language versions with mise
echo -e "${BLUE}🌐 Installing language versions with mise...${NC}"
require_command mise

mise install

echo -e "${GREEN}✅ Language versions configured${NC}"

echo
echo -e "${PURPLE}🎉 Installation completed successfully!${NC}"
echo
echo -e "${CYAN}📝 Next steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Install language versions with mise (e.g., mise install)"
echo "  3. Configure your applications as needed"
echo
echo -e "${GREEN}🚀 Happy coding!${NC}"
