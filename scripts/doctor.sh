#!/usr/bin/env bash

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILED=0

info() {
  printf '\n\033[0;34m==> %s\033[0m\n' "$1"
}

pass() {
  printf '\033[0;32m✓\033[0m %s\n' "$1"
}

warn() {
  printf '\033[1;33m!\033[0m %s\n' "$1"
}

fail() {
  printf '\033[0;31m✗\033[0m %s\n' "$1"
  FAILED=1
}

has() {
  command -v "$1" >/dev/null 2>&1
}

run_check() {
  local label="$1"
  shift

  if "$@"; then
    pass "$label"
  else
    fail "$label"
  fi
}

check_required_tools() {
  info "Required Tools"

  local tools=(brew git stow zsh)
  local optional_tools=(mise just opencode shellcheck nvim tmux)
  local tool

  for tool in "${tools[@]}"; do
    if has "$tool"; then
      pass "$tool found"
    else
      fail "$tool missing"
    fi
  done

  for tool in "${optional_tools[@]}"; do
    if has "$tool"; then
      pass "$tool found"
    else
      warn "$tool missing"
    fi
  done
}

check_shell() {
  info "Shell"

  run_check "zsh config syntax" zsh -n "$ROOT/home/.zprofile" "$ROOT/home/.zshrc" "$ROOT/aliases.zsh" "$ROOT/path.zsh"

  if has shellcheck; then
    run_check "install.sh shellcheck" shellcheck "$ROOT/install.sh"
  else
    warn "shellcheck unavailable; skipped install.sh lint"
  fi
}

check_stow() {
  info "Stow"

  if ! has stow; then
    warn "stow unavailable; skipped symlink simulation"
    return
  fi

  mkdir -p "$HOME/.config"
  run_check "home package dry-run" stow --no --restow -d "$ROOT" -t "$HOME" home
  run_check "config package dry-run" stow --no --restow -d "$ROOT" -t "$HOME/.config" config
}

check_brew() {
  info "Homebrew"

  if ! has brew; then
    warn "brew unavailable; skipped Brewfile check"
    return
  fi

  if HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --file "$ROOT/Brewfile" >/tmp/dotfiles-brew-check.log 2>&1; then
    pass "Brewfile dependencies satisfied"
  else
    warn "Brewfile has missing dependencies"
    sed 's/^/  /' /tmp/dotfiles-brew-check.log
  fi
}

check_mise() {
  info "mise"

  if ! has mise; then
    warn "mise unavailable; skipped version check"
    return
  fi

  if mise current >/tmp/dotfiles-mise-current.log 2>&1; then
    pass "mise versions resolved"
  else
    warn "mise reported unresolved versions"
  fi
  sed 's/^/  /' /tmp/dotfiles-mise-current.log
}

check_opencode() {
  info "opencode"

  if has opencode; then
    if opencode debug config >/tmp/dotfiles-opencode-config.log 2>&1; then
      pass "opencode config resolves"
    else
      fail "opencode config resolves"
      sed 's/^/  /' /tmp/dotfiles-opencode-config.log
    fi
  else
    warn "opencode unavailable; skipped config validation"
  fi
}

check_nvim() {
  info "Neovim"

  if has nvim; then
    run_check "Neovim starts headless" nvim --headless '+qall'
  else
    warn "nvim unavailable; skipped headless startup"
  fi
}

check_startup_time() {
  info "Shell Startup"

  if has zsh; then
    /usr/bin/time -p zsh -i -c exit
  else
    warn "zsh unavailable; skipped startup timing"
  fi
}

main() {
  check_required_tools
  check_shell
  check_stow
  check_brew
  check_mise
  check_opencode
  check_nvim
  check_startup_time

  if (( FAILED )); then
    printf '\n\033[0;31mDoctor found issues.\033[0m\n'
    exit 1
  fi

  printf '\n\033[0;32mDoctor passed.\033[0m\n'
}

main "$@"
