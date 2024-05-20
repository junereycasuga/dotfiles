# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadcli="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll='exa --long --header --git --links --group-directories-first --color-scale --time-style=iso --grid --across'
alias c="clear"

# Directories
alias dotfiles="cd $DOTFILES"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"

# Docker
alias d='docker'
alias dstop="docker stop $(docker ps -a -q)"
alias dpurgecontainers="dstop && docker rm $(docker ps -a -q)"
alias dpurgeimages="docker rmi $(docker images -q)"
dbuild() { docker build -t=$1 .; }
dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }
docker_prune() { docker system prune --volumes -fa }

# Git
alias git-prune='git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d'
alias gsm='git smart-merge'
alias gsp='git smart-pull'
alias gst='git status'

# TMUX
alias tmux="tmux -2"

# Vim
alias v="nvim"

# Terraform
alias t='terraform'

alias db='gobang'

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor        # get more colors
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
bindkey -s "\C-r" "\eqhstr\n"     # bind hstr to Ctrl-r (for Vi mode check doc)

# Source asdf
. "$HOME/.asdf/asdf.sh"
