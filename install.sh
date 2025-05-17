#!/usr/bin/bash

# install system packages (requires sudo)
install_packages() {
    if ! type sudo > /dev/null; then
        echo "sudo is not installed/configured: skipping package install for now"
        return
    fi
    sudo pacman -S - < packages.txt
}

# install config files
install_configs() {
    mkdir -p $HOME/.config
    cp -r config/* $HOME/.config/
    cp vimrc $HOME/.vimrc
    cp zshrc $HOME/.zshrc

    # install secret files, if available (cloned)
    if [ -d dots-secrets ]; then
        cd dots-secrets
        source install.sh
        cd ..
    else
        echo "dots-secrets was not cloned. if you have access, use --recurse-submodules when cloning."
    fi
}

while getopts ":cp" opt; do
    case "$opt" in
        c)
            install_configs
            ;;
        p)
            install_packages
            ;;
    esac
done
