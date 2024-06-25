#!/bin/bash

# font: fira
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz | sudo tar xf - -J -C /usr/share/fonts/
rm FiraCode.tar.xz

# font: iosevka
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.tar.xz | sudo tar xf - -J -C /usr/share/fonts/
rm IosevkaTerm.tar.xz
