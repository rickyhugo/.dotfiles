#!/bin/bash

sudo apt update
sudo apt install lua5.4 liblua5.4-dev luarocks -y
lua -v
luarcks --version
