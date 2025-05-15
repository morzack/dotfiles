# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="flazz"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 14

plugins=(git fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

alias l="ls"

HISTFILE=~/.histfile
HISTSIZE=9999999
SAVEHIST=9999999

unsetopt beep
bindkey -e

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
