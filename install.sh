#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")"
git pull origin master

function install()
{
    local INSTALL_DIR="$HOME/.local/bin"
    mkdir -p $INSTALL_DIR
    cp favdir.sh "$INSTALL_DIR"

    local msg=$(
    cat <<-EOF
    If you did not write the following, and write it to your shell rc file
    Add 'source ~/.local/bin/favdir.sh' to ~/.bashrc or ~/.zshrc
    , and  re-start your shell...
    EOF
    );
    echo "$msg"
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install;
fi
