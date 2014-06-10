#!/usr/bin/env bash

#INSTALL_DIR=~/.local/bin
#INSTALL_FILE=favdir.sh
#FAVDIR=~/.favdir

cd "$(dirname "${BASH_SOURCE}")"

git pull origin master

doInstall()
{
	local INSTALL_DIR="$HOME/.local/bin"
	mkdir -p $INSTALL_DIR
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "install.sh" \
		--exclude "Makefile" --exclude "README.md" -avh --no-perms . $INSTALL_DIR
	echo "If you did not write the following, and write it to your shell rc file"
	echo "Add 'source ~/.local/bin/favdir.sh' to ~/.bashrc or ~/.zshrc"
	echo ", and  re-start your shell..."
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doInstall;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doInstall;
	fi
fi
unset doInstall
