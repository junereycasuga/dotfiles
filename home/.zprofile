# Login-shell environment. Keep interactive shell behavior in .zshrc.
export DOTFILES=${DOTFILES:-$HOME/.dotfiles}

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

source "$DOTFILES/path.zsh"

export EDITOR=${EDITOR:-nvim}
export KUBE_EDITOR=${KUBE_EDITOR:-nvim}
export AIDER_EDITOR=${AIDER_EDITOR:-nvim}
export RAINFROG_CONFIG=${RAINFOG_CONFIG:-$HOME/.config/rainfrog}

# Added by OrbStack: command-line tools and integration
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || true

path=(
  /Applications/Obsidian.app/Contents/MacOS
  $path
)
