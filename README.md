# dotfiles

dotfiles for my current linux setup

![demo](scrot.png)

This repo contains scripts and the required resource files to quickly reproduce my working environment in a fresh Arch Linux installation.

core packages:
- [labwc](https://labwc.github.io/) (wayland compositor)
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) (bar, launcher, notifications, lock, wallpaper/theming via matugen) — packaged as `dux-shell`
- kanshi (output configuration)
- greetd + tuigreet (login)
- alacritty
- helix / vim
- zsh

It's assumed that an AUR helper (e.g. [yay](https://github.com/Jguer/yay)) has already been installed, though everything in `packages.txt` is currently in the official repos.
`packages.txt` only lists what the configs here actually need (compositor, shell, login, audio, terminal/editors, a base font set); machine-specific packages (microcode, GPU drivers, kernels) and standalone applications are left to you.

background in the screenshot is [嵯峨 by Katann](https://www.pixiv.net/en/artworks/88127737)

## layout

```
config/          -> ~/.config/  (labwc, kanshi, dms, alacritty, helix, environment.d)
local/bin/       -> ~/.local/bin/  (screenshot, desk: role -> dms ipc wrapper)
system/greetd/   -> /etc/greetd/
zshrc, vimrc, ashrc, profile -> ~/.zshrc, ~/.vimrc, ~/.ashrc, ~/.profile
resources/       wallpapers
dots-secrets/    private submodule (git/ssh config)
```

## installation

An install script `./install.sh` is provided:

```bash
./install.sh -p    # installs packages
./install.sh -c    # installs user config
./install.sh -s    # installs greetd config + enables greetd (sudo)

./install.sh -pcs  # all of the above

./install.sh -d    # check this machine against the repo, change nothing (-dv for diffs)
```

`-d` installs into a temporary HOME and diffs it against the real one, so it covers exactly what `-c` installs (including `dots-secrets`).
It also checks packages, greetd, the dms service hook, that configs parse, and that every command in the labwc config resolves on the session PATH.

`~/.profile` puts `~/.local/bin` on PATH for the labwc session (greetd sources it); `environment.d/` does the same for systemd user services like dms.

`install.sh -c` also hooks `dms.service` into `labwc-session.target`, which `labwc/autostart` starts, so the shell comes up with the session.

To get things working, manually, you need to:
- edit `~/.config/kanshi/config` to match your outputs
- optionally pin the tablet to an output with `mapToOutput` in `labwc/rc.xml`
- pick a wallpaper in dms (matugen regenerates `alacritty/dank-theme.toml` from it)
