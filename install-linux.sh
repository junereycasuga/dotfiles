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

if [[ $(uname -s) != "Linux" ]]; then
    echo -e "${RED}❌ This script is for Linux only. Use ./install.sh on macOS.${NC}"
    exit 1
fi

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo -e "${RED}❌ Required command not found: $1${NC}"
        exit 1
    fi
}

show_splash() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
     ██╗██╗   ██╗███╗   ██╗██╗██╗  ██╗
     ██║██║   ██║████╗  ██║██║╚██╗██╔╝
     ██║██║   ██║██╔██╗ ██║██║ ╚███╔╝
██   ██║██║   ██║██║╚██╗██║██║ ██╔██╗
╚█████╔╝╚██████╔╝██║ ╚████║██║██╔╝ ██╗
 ╚════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
EOF
    echo -e "${NC}"
    echo
    echo -e "${PURPLE}🐧 Welcome to JUNIX — Junerey's Linux Development Environment${NC}"
    echo -e "${YELLOW}📦 Debian/Ubuntu bootstrap sharing the dotfiles zsh configuration with the Mac${NC}"
    echo
    echo -e "${BLUE}What this setup includes:${NC}"
    echo "  • autoconf, ack, zlib, grep, libyaml, tree, zsh, zsh-completions, openssl"
    echo "  • neovim, jq, yq, httpie, mise, antidote, eza, ripgrep, 1password-cli"
    echo "  • zoxide, fzf, stow, bat, atuin, carapace, worktrunk, lazygit"
    echo "  • Zsh with Starship prompt (same config as the Mac)"
    echo
    echo -e "${BLUE}How tools are installed:${NC}"
    echo "  • apt: system libraries and CLI utilities"
    echo "  • mise github backend: eza, atuin, carapace, worktrunk, lazygit, yq, starship"
    echo "  • official installers/scripts: mise, zoxide (fallback), antidote, zsh-completions"
    echo
    echo -e "${YELLOW}⚠️  This script will:${NC}"
    echo "  • Install system packages (sudo required)"
    echo "  • Add the 1Password apt repository"
    echo "  • Back up conflicting dotfiles (~/.gitconfig, ~/.zshrc, ~/.config/*)"
    echo "  • Create symlinks for configuration files"
    echo
}

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

show_splash
confirm_installation

# Install system packages (Debian/Ubuntu)
echo -e "${BLUE}📦 Installing system packages...${NC}"

# 1Password official apt repository (https://developer.1password.com/docs/cli/get-started)
# Note: the repo URL embeds the arch path and uses suite "stable" —
# the older "suite = arch" layout no longer resolves a Release file.
if ! grep -q 'stable main' /etc/apt/sources.list.d/1password.list 2>/dev/null; then
    echo -e "${BLUE}🔑 Adding 1Password apt repository...${NC}"
    curl -sS https://downloads.1password.com/linux/keys/1password.asc \
        | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" \
        | sudo tee /etc/apt/sources.list.d/1password.list >/dev/null
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol \
        | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol >/dev/null
    curl -sS https://downloads.1password.com/linux/keys/1password.asc \
        | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
fi

sudo apt-get update
sudo apt-get install -y \
    ca-certificates curl wget git gnupg locales \
    autoconf zlib1g-dev grep libyaml-dev tree zsh openssl libssl-dev \
    neovim jq httpie ripgrep fzf stow bat 1password-cli
sudo locale-gen en_GB.UTF-8 2>/dev/null || true

# ack: package is `ack` on Ubuntu, `ack-grep` on Debian
if ! sudo apt-get install -y ack; then
    sudo apt-get install -y ack-grep
fi

# zoxide: absent from Debian 12 and earlier — fall back to the install script
if ! sudo apt-get install -y zoxide; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi
echo -e "${GREEN}✅ System packages installed${NC}"

# Debian/Ubuntu name some binaries differently — bridge them in ~/.bin
echo -e "${BLUE}🔗 Bridging distro binary names...${NC}"
mkdir -p "$HOME/.bin"
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -sf "$(command -v batcat)" "$HOME/.bin/bat"
    echo -e "${GREEN}  bat -> batcat${NC}"
fi
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$HOME/.bin/fd"
    echo -e "${GREEN}  fd -> fdfind${NC}"
fi
echo -e "${GREEN}✅ Binary names bridged${NC}"

# Install mise (official installer) and make it findable on PATH
echo -e "${BLUE}🌐 Installing mise...${NC}"
if ! command -v mise >/dev/null 2>&1; then
    curl https://mise.run | sh
    ln -sf "$HOME/.local/share/mise/bin/mise" "$HOME/.bin/mise"
    echo -e "${GREEN}✅ mise installed${NC}"
else
    echo -e "${GREEN}✅ mise already installed${NC}"
fi

# Install antidote (zsh plugin manager, cloned where .zshrc expects it)
echo -e "${BLUE}💉 Installing antidote...${NC}"
if [[ ! -d "${ZDOTDIR:-$HOME}/.antidote" ]]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR:-$HOME}/.antidote"
    echo -e "${GREEN}✅ Antidote installed${NC}"
else
    echo -e "${GREEN}✅ Antidote already installed${NC}"
fi

# zsh-completions has no Debian/Ubuntu package — clone it (.zshrc adds it to fpath)
echo -e "${BLUE}🐚 Installing zsh-completions...${NC}"
if [[ ! -d "$HOME/.zsh-completions" ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$HOME/.zsh-completions"
    echo -e "${GREEN}✅ zsh-completions cloned to ~/.zsh-completions${NC}"
else
    echo -e "${GREEN}✅ zsh-completions already cloned${NC}"
fi

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

# Symlink dotfiles using GNU Stow (same packages as macOS)
echo -e "${BLUE}🔗 Creating configuration symlinks...${NC}"
require_command stow
mkdir -p "$HOME/.config"
stow --restow -t ~ home
stow --restow -t ~/.config config
echo -e "${GREEN}✅ Configuration files symlinked${NC}"

# Install language versions and Linux-only CLI tools (config.linux.toml) with mise.
# The github backend downloads release binaries (eza, atuin, carapace, worktrunk,
# lazygit, yq, starship) — replacing per-tool install scripts.
echo -e "${BLUE}🌐 Installing languages and CLI tools with mise...${NC}"
require_command mise
MISE_ENV=linux mise install
echo -e "${GREEN}✅ mise tools installed${NC}"

# Make zsh the default shell
echo -e "${BLUE}🐚 Setting zsh as the default shell...${NC}"
ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    if grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        chsh -s "$ZSH_PATH"
        echo -e "${GREEN}✅ Default shell changed to zsh${NC}"
    else
        echo -e "${YELLOW}⚠️  $ZSH_PATH not in /etc/shells — add it, then run: chsh -s $ZSH_PATH${NC}"
    fi
else
    echo -e "${GREEN}✅ zsh is already the default shell${NC}"
fi

echo
echo -e "${YELLOW}ℹ️  Notes:${NC}"
echo "  • mise compiles Python/Rust from source — if builds fail, install build"
echo "    tools first: sudo apt-get install -y build-essential libssl-dev zlib1g-dev \\"
echo "      libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils \\"
echo "      tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"
echo "  • carapace is installed but not initialised — add 'eval \"\$(carapace zsh)\"' to enable it"

echo
echo -e "${PURPLE}🎉 Installation completed successfully!${NC}"
echo
echo -e "${CYAN}📝 Next steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Antidote will clone zsh plugins on first shell start"
echo "  3. Run 'just doctor' (or ./scripts/doctor.sh) to verify the setup"
echo
echo -e "${GREEN}🚀 Happy coding!${NC}"
