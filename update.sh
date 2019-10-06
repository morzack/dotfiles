#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dots"

# config folders
cp -r ~/.config/compton ${BASEDIR}/config/
cp -r ~/.config/gtk-3.0 ${BASEDIR}/config/
cp -r ~/.config/i3 ${BASEDIR}/config/
cp -r ~/.config/neofetch ${BASEDIR}/config/
cp -r ~/.config/nvim ${BASEDIR}/config/
cp -r ~/.config/polybar ${BASEDIR}/config/
cp -r ~/.config/termite ${BASEDIR}/config/
cp -r ~/.config/twmn ${BASEDIR}/config/
cp -r ~/.config/wal-discord ${BASEDIR}/config/

# zsh stuff
cp ~/.zprofile ${BASEDIR}/zprofile
cp ~/.zshrc ${BASEDIR}/zshrc
