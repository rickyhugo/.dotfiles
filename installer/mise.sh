#!/bin/bash

curl https://mise.run | sh
~/.local/bin/mise --version
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
echo '.mise.toml' >> "$MY_GITIGNORE"
mise use -g python
mise use -g node
mise use -g go

# NOTE: setup python client for neovim
python -m pip install pynvim
