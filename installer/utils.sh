#!/bin/bash

sudo apt update

sudo apt install -y \
    git-all \
    xclip \
    stow \
    jq \
    bat \
    playerctl \
    brightnessctl

# NOTE: control backlight laptop, reboot required
sudo usermod -aG video "$USER"

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
