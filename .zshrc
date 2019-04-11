# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/reimu/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall

export PATH=$PATH:~/.local/bin

prompt suse
