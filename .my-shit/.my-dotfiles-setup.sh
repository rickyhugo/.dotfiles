#!/bin/bash

# NOTE: main machine
mkdir ~/.dotfiles
echo "alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> .my-aliases
. ~/.zshrc
dotfiles init
dotfiles config --local status.showUntrackedFiles no
dotfiles branch -M main
dotfiles remote add origin https://github.com/rickyhugo/.dotfiles.git

# NOTE: other machines
echo "alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> .my-aliases
. ~/.zshrc
git clone --bare https://github.com/rickyhugo/.dotfiles.git
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
