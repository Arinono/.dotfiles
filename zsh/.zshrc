export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_BIN_HOME=$HOME/.local/bin
export ZSH="$HOME/.oh-my-zsh"

pathadd() {
  newelement=${1%/}
  if [ -d "$1" ] && ! echo $PATH | grep -E -q "(^|:)$newelement($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH="$PATH:$newelement"
    else
      PATH="$newelement:$PATH"
    fi
  fi
}

prependPath() {
  pathadd "$1"
}

appendPath() {
  pathadd "$1" after
}

export HOMEBREW_PREFIX=`/opt/homebrew/bin/brew --prefix`

prependPath $HOMEBREW_PREFIX/bin
prependPath $HOMEBREW_PREFIX/sbin
prependPath $HOME/.go/bin
prependPath $HOME/.cargo/bin
prependPath $HOME/.local/bin
appendPath /Applications/Ghostty.app/Contents/MacOS

# ohmyz.sh
ZSH_THEME="robbyrussell"

# Enable plugins.
plugins=(git git-auto-fetch)

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

source ~/.zsh_profile
export GPG_TTY=$TTY
