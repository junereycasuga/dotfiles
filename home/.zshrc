# Path to your dotfiles installation.
export DOTFILES=${DOTFILES:-$HOME/.dotfiles}

# Set nvim as default editor
export EDITOR=${EDITOR:-nvim}
export KUBE_EDITOR=${KUBE_EDITOR:-nvim}

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$DOTFILES

autoload -Uz compinit
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null || print 0)
if [[ $(date +'%j') != $updated_at ]]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell

setopt auto_cd # cd by typing directory name if it's not a command
setopt correct_all # autocorrect commands

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt complete_in_word # allow completion from within a word/phrase

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' accept-exact '*(N)' # Speedup path completion

# Cache expensive completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

# paths
source $ZSH_CUSTOM/path.zsh

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# aliases
source $ZSH_CUSTOM/aliases.zsh

if [[ -r ${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.zsh ]]; then
  source ${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.zsh
fi

if command -v terraform >/dev/null 2>&1; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "$(command -v terraform)" terraform
fi

# Makes a directory and changes to it.
function mkdcd() {
  [[ -n "$1" ]] && mkdir -p "$1" && cd "$1"
}

# initialize zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# initialize starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# FZF
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .ti"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

export FZF_TMUX_OPTS=" -p90%,79% "

export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

export AIDER_EDITOR=${AIDER_EDITOR:-nvim}
export RAINFROG_CONFIG=${RAINFOG_CONFIG:-$HOME/.config/rainfrog}

if [[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1; then
  kiro_integration="$(kiro --locate-shell-integration-path zsh)"
  [[ -r "$kiro_integration" ]] && source "$kiro_integration"
  unset kiro_integration
fi

if command -v wt >/dev/null 2>&1; then
  eval "$(command wt config shell init zsh)"
fi
