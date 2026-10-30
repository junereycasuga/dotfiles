# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Platform system dirs: Homebrew on macOS, standard prefixes on Linux
# (Linux has no Homebrew — packages come from the distro, see install-linux.sh)
typeset -U path PATH
if [[ $(uname -s) == "Darwin" ]]; then
  brew_prefix=/opt/homebrew
  [[ -d $brew_prefix/bin ]] || brew_prefix=/usr/local
  path=(
    $brew_prefix/bin
    $brew_prefix/sbin
    /usr/local/bin
    /usr/local/sbin
    $path
  )
  unset brew_prefix
else
  # Activates ~/.config/mise/config.linux.toml (Linux-only mise tools)
  export MISE_ENV=linux
  path=(
    /usr/local/bin
    /usr/local/sbin
    $HOME/.local/bin
    $path
  )
fi

# Local bin directories before anything else
path=(
  $HOME/.yarn/bin
  $HOME/.config/yarn/global/node_modules/.bin
  $HOME/.fastlane/bin
  $HOME/.lmstudio/bin
  $HOME/.bin
  $path
)

# Strip inherited asdf paths (migrated to mise)
path=("${(@)path:#$HOME/.asdf/shims}")
path=("${(@)path:#$HOME/.asdf/bin}")

# Where to find the zsh history
export HISTFILE=${HOME}/.zsh_history

# Locales
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# Homebrew zlib flags for building Erlang on macOS
if [[ $(uname -s) == "Darwin" ]]; then
  if [[ -d /opt/homebrew/opt/zlib ]]; then
    zlib_prefix=/opt/homebrew/opt/zlib
  elif [[ -d /usr/local/opt/zlib ]]; then
    zlib_prefix=/usr/local/opt/zlib
  fi
fi

if [[ -n ${zlib_prefix:-} ]]; then
  zlib_ldflag="-L${zlib_prefix}/lib"
  zlib_cppflag="-I${zlib_prefix}/include"
  zlib_pkg_config_path="${zlib_prefix}/lib/pkgconfig"

  [[ " ${LDFLAGS:-} " == *" ${zlib_ldflag} "* ]] || export LDFLAGS="${LDFLAGS:+$LDFLAGS }${zlib_ldflag}"
  [[ " ${CPPFLAGS:-} " == *" ${zlib_cppflag} "* ]] || export CPPFLAGS="${CPPFLAGS:+$CPPFLAGS }${zlib_cppflag}"
  [[ ":${PKG_CONFIG_PATH:-}:" == *":${zlib_pkg_config_path}:"* ]] || export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}${zlib_pkg_config_path}"

  unset zlib_ldflag zlib_cppflag zlib_pkg_config_path
  unset zlib_prefix
fi

# For erlang installations, removes java dependency
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

# iex history
export ERL_AFLAGS="-kernel shell_history enabled"

# default node.js environment
export NODE_ENV="development"

# set up hh colours
export HSTR_CONFIG=keywords-matching,hicolor

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export K9S_CONFIG_DIR="$HOME/.config/k9s"
