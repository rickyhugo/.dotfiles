#!/bin/bash

DOTFILES=https://github.com/rickyhugo/.dotfiles.git

# NOTE: main machine
mkdir ~/.dotfiles
echo "alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> .my-shit/aliases.sh
. ~/.zshrc
dotfiles init
dotfiles config --local status.showUntrackedFiles no
dotfiles branch -M main
dotfiles remote add origin "$DOTFILES"

# NOTE: other machines
echo "alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> .my-shit/aliases.sh
. ~/.zshrc
git clone --bare "$DOTFILES"
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
