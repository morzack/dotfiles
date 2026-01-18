# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

export PATH="$HOME/.local/bin:$PATH"

alias l="ls"
HISTFILE=~/.histfile
HISTSIZE=9999999
SAVEHIST=9999999
unsetopt beep
bindkey -e

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

setopt HIST_IGNORE_SPACE

autoload -Uz promptinit
promptinit
prompt redhat

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

export ROCM_PATH=/opt/rocm
export HSA_OVERRIDE_GFX_VERSION=11.0.0

