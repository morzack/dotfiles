#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dots"

# config folders
cp -r ${BASEDIR}/config/* ~/.config/

# bashrc stuff
cp ${BASEDIR}/bash_profile ~/.bash_profile
cp ${BASEDIR}/bashrc ~/.bashrc

# resources folder
mkdir -p ~/resources
cp -r ${BASEDIR}/resources/* ~/resources

# x server files
cp ${BASEDIR}/xinitrc ~/.xinitrc
cp ${BASEDIR}/Xresources ~/.Xresources

# zsh stuff
cp ${BASEDIR}/zprofile ~/.zprofile
cp ${BASEDIR}/zshrc ~/.zshrc
