#!/usr/bin/env bash

sudo apt update
xargs sudo apt -y install <apt.txt

./stow.sh

# NOTE: control backlight laptop, reboot required
sudo usermod -aG video "$USER"
