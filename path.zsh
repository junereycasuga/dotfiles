# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Local bin directories before anything else
typeset -U path PATH
path=(
  /opt/homebrew/bin
  /usr/local/bin
  /usr/local/sbin

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

if [[ -d /opt/homebrew/opt/zlib ]]; then
  zlib_prefix=/opt/homebrew/opt/zlib
elif [[ -d /usr/local/opt/zlib ]]; then
  zlib_prefix=/usr/local/opt/zlib
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
