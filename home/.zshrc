# Path to your dotfiles installation.
export DOTFILES=$HOME/.dotfiles

# Set nvim as default editor
export EDITOR=nvim
export KUBE_EDITOR=nvim

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$DOTFILES

autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
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

autoload -U +X bashcompinit && bashcompinit

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
source ${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.zsh

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

complete -o nospace -C /usr/local/bin/terraform terraform

# Makes a directory and changes to it.
function mkdcd() {
  [[ -n "$1" ]] && mkdir -p "$1" && cd "$1"
}

# initialize zoxide
eval "$(zoxide init zsh)"

# initialize starship
eval "$(starship init zsh)"

# FZF
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .ti"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

export FZF_TMUX_OPTS=" -p90%,79% "

export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/junereycasuga/.lmstudio/bin"
eval "$(atuin init zsh)"

export AIDER_EDITOR=nvim
export RAINFROG_CONFIG=~/.config/rainfrog

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/junerey/.lmstudio/bin"
# End of LM Studio CLI section

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
