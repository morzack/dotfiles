#!/usr/bin/bash
# usage:
#   ./install.sh -p   install packages (packages.txt, via yay if present, else pacman)
#   ./install.sh -c   install user config (~/.config, ~/.local/bin, shell rc files)
#   ./install.sh -s   install system config (greetd) and enable services (requires sudo)
#   ./install.sh -pcs everything
#   ./install.sh -d   check this machine against the repo (no changes; add -v for diffs)

set -e
cd "$(dirname "$(realpath "$0")")"

# install system packages (requires sudo)
install_packages() {
    if ! type sudo > /dev/null 2>&1; then
        echo "sudo is not installed/configured: skipping package install for now"
        return
    fi
    pkgs=$(grep -v '^\s*#' packages.txt | grep -v '^\s*$')
    if type yay > /dev/null 2>&1; then
        yay -S --needed $pkgs
    else
        sudo pacman -S --needed $pkgs
    fi
}

# copy user files into $HOME (also used by check, against a temp HOME)
copy_files() {
    mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/Pictures/Screenshots"
    cp -r config/* "$HOME/.config/"
    cp local/bin/* "$HOME/.local/bin/"
    cp vimrc "$HOME/.vimrc"
    cp zshrc "$HOME/.zshrc"
    cp ashrc "$HOME/.ashrc"
    cp profile "$HOME/.profile"

    # install secret files, if available (cloned)
    if [ -f dots-secrets/install.sh ]; then
        (cd dots-secrets && source install.sh)
    else
        echo "dots-secrets was not cloned. if you have access, use --recurse-submodules when cloning."
    fi
}

# install user config files
install_configs() {
    copy_files

    # start DankMaterialShell with the labwc session
    # (labwc/autostart starts labwc-session.target)
    if type systemctl > /dev/null 2>&1; then
        systemctl --user add-wants labwc-session.target dms.service || true
    fi
}

# install system-level config (requires sudo)
install_system() {
    if ! type sudo > /dev/null 2>&1; then
        echo "sudo is not installed/configured: skipping system install for now"
        return
    fi
    sudo install -Dm644 system/greetd/config.toml /etc/greetd/config.toml
    sudo systemctl enable greetd.service
}

# compare this machine against the repo. prints problems, returns nonzero if any.
check() {
    local bad=0 tmp f rel live
    ok()   { printf '  \e[32mok\e[0m    %s\n' "$*"; }
    fail() { printf '  \e[31mFAIL\e[0m  %s\n' "$*"; bad=1; }
    warn() { printf '  \e[33mwarn\e[0m  %s\n' "$*"; }

    echo "files (repo -> \$HOME):"
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' RETURN
    HOME="$tmp" copy_files > /dev/null
    local nfiles=0
    while IFS= read -r -d '' f; do
        rel=${f#"$tmp"/}; live="$HOME/$rel"; nfiles=$((nfiles + 1))
        if [ ! -e "$live" ]; then
            fail "~/$rel missing"
        elif ! cmp -s "$f" "$live"; then
            fail "~/$rel differs"
            case "$rel" in .ssh/*|.gitconfig*) continue ;; esac  # don't print secrets
            [ -n "$verbose" ] && diff -u --label "repo/$rel" --label "~/$rel" "$f" "$live" | sed 's/^/        /'
        elif [ -x "$f" ] && [ ! -x "$live" ]; then
            fail "~/$rel not executable"
        fi
    done < <(find "$tmp" -type f -print0)
    [ "$bad" = 0 ] && ok "all $nfiles files match"

    echo "packages:"
    local missing
    missing=$(grep -v '^\s*#' packages.txt | grep -v '^\s*$' | xargs pacman -T || true)
    if [ -n "$missing" ]; then fail "not installed: $(echo $missing)"; else ok "all packages.txt packages installed"; fi

    echo "system:"
    if cmp -s system/greetd/config.toml /etc/greetd/config.toml; then ok "/etc/greetd/config.toml matches"
    else fail "/etc/greetd/config.toml differs (./install.sh -s)"
         [ -n "$verbose" ] && diff -u --label repo --label /etc system/greetd/config.toml /etc/greetd/config.toml | sed 's/^/        /'
    fi
    if systemctl is-enabled -q greetd.service 2>/dev/null; then ok "greetd enabled"; else fail "greetd not enabled"; fi
    if [ -e "$HOME/.config/systemd/user/labwc-session.target.wants/dms.service" ]; then ok "dms wanted by labwc-session.target"
    else fail "dms not hooked into labwc-session.target (./install.sh -c)"; fi

    echo "sanity:"
    if command -v xmllint > /dev/null; then
        xmllint --noout config/labwc/rc.xml 2>/dev/null && ok "labwc/rc.xml is well-formed" || fail "labwc/rc.xml is not well-formed XML"
    else warn "xmllint not found, skipping rc.xml check"; fi
    python3 -c 'import json,sys; json.load(open(sys.argv[1]))' config/dms/settings.json 2>/dev/null \
        && ok "dms/settings.json is valid JSON" || fail "dms/settings.json is not valid JSON"
    for f in local/bin/* config/labwc/autostart config/labwc/shutdown profile ashrc; do
        sh -n "$f" 2>/dev/null || fail "$f has sh syntax errors"
    done
    zsh -n zshrc 2>/dev/null || fail "zshrc has zsh syntax errors"
    ok "shell scripts parse"
    # what labwc sees when greetd launches it (greetd sources /etc/profile and ~/.profile)
    local sess_path
    sess_path=$(env -i HOME="$HOME" /bin/sh -c '[ -f /etc/profile ] && . /etc/profile; [ -f "$HOME/.profile" ] && . "$HOME/.profile"; echo "$PATH"')
    for f in local/bin/*; do
        PATH="$sess_path" command -v "$(basename "$f")" > /dev/null \
            && ok "$(basename "$f") on the session PATH" || fail "$(basename "$f") not on the session PATH"
    done
    # every command bound in rc.xml / autostart should resolve on the session PATH
    local cmd
    for cmd in $( { grep -o 'command="[^"]*"' config/labwc/rc.xml | sed 's/command="//; s/"$//'
                    grep -v '^\s*#' config/labwc/autostart; } | awk '{print $1}' | sort -u); do
        PATH="$sess_path" command -v "$cmd" > /dev/null || warn "'$cmd' (used in labwc config) not found on the session PATH"
    done

    return $bad
}

do_p=; do_c=; do_s=; do_d=; verbose=
while getopts ":cpsdv" opt; do
    case "$opt" in
        c) do_c=1 ;;
        p) do_p=1 ;;
        s) do_s=1 ;;
        d) do_d=1 ;;
        v) verbose=1 ;;
        *) echo "unknown flag: -$OPTARG" >&2; exit 2 ;;
    esac
done

if [ -n "$do_d" ]; then
    check
    exit $?
fi

if [ -z "$do_p$do_c$do_s" ]; then
    sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
fi

# packages first so units/binaries referenced by the configs exist
[ -n "$do_p" ] && install_packages
[ -n "$do_s" ] && install_system
[ -n "$do_c" ] && install_configs
exit 0
