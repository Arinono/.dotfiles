export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_BIN_HOME=$HOME/.local/bin
export ZSH="$HOME/.oh-my-zsh"

# ohmyz.sh
ZSH_THEME="robbyrussell"

# Enable plugins.
plugins=(git git-auto-fetch asdf)

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

source ~/.zsh_profile
export GPG_TTY=$TTY
