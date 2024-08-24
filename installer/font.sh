#!/bin/bash

# font: fira
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz | sudo tar xf - -J -C /usr/share/fonts/

# font: iosevka
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.tar.xz | sudo tar xf - -J -C /usr/share/fonts/

# font: jetbrains mono
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -o jetbrains.zip
unzip jetbrains.zip -d /usr/share/fonts/
rm jetbrains.zip
