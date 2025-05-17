# dotfiles

dotfiles for my current linux setup

![demo](scrot.png)

This repo contains scripts and the required resource files to quickly reproduce my working environment in a fresh Arch Linux installation.

core packages:
- i3wm
- polybar
- rofi
- kitty
- picom
- dunst
- oh-my-zsh

It's assumed that some package manager aside from `pacman` (e.g. [yay](https://github.com/Jguer/yay)) has already been installed.
(some packages used in this install exist in AUR).
Additionally, the tooling here can attempt to install a nontrivial number of packages beyond the minimum needed to reproduce the setup.
Keep this in mind. Ideally (this is a TODO) there will be some flag attached to any installation scripting that will select between a more minimal install and the full installation.

background is [嵯峨 by Katann](https://www.pixiv.net/en/artworks/88127737)


## installation

An install script `./install.sh` is provided.
This script has two flags:

```bash
./install.sh c # installs config
./install.sh p # installs packages

./install.sh p c # does both
```

To get things working, manually, you need to:
- update ~/.config/polybar/config to make the main bar point to the correct monitor and fit the screen
- set up arandr to make an autolaunching display config
- install oh-my-zsh, then move the zshrc to replace the autogen one

