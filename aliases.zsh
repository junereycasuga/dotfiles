# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadcli="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll='eza --long --header --git --links --group-directories-first --color-scale --time-style=iso --grid --icons'
alias c="clear"

alias ~="cd ~"
alias desktop="cd $HOME/Desktop"
alias downloads="cd $HOME/Downloads"
alias documents="cd $HOME/Documents"
alias projects="cd $HOME/projects"

# Directories
alias dotfiles="cd $DOTFILES"

# Docker
alias d='docker'
dstop() {
  local containers
  containers=(${(f)"$(docker ps -a -q)"})
  (( ${#containers[@]} )) && docker stop "${containers[@]}"
}
dpurgecontainers() {
  local containers
  containers=(${(f)"$(docker ps -a -q)"})
  (( ${#containers[@]} )) && docker rm -f "${containers[@]}"
}
dpurgeimages() {
  local images
  images=(${(f)"$(docker images -q)"})
  (( ${#images[@]} )) && docker rmi "${images[@]}"
}
dbuild() { docker build -t="$1" .; }
dbash() {
  local container
  container="$(docker ps -aqf "name=$1" | head -n 1)"
  [[ -n "$container" ]] && docker exec -it "$container" bash
}
docker_prune() { docker system prune --volumes -fa; }

# Git
alias git-prune='git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d'
alias gsm='git smart-merge'
alias gsp='git smart-pull'
alias gst='git status'

# Vim
alias v="nvim"

# Terraform
alias t='terraform'

alias db='rainfrog'

aero_windows() {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}
alias ff='aero_windows'

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
bindkey -s "\C-r" "\eqhstr\n"     # bind hstr to Ctrl-r (for Vi mode check doc)

