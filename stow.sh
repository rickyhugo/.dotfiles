#!/usr/bin/bash

cd config || exit
stow --verbose --target="$HOME" --restow -- */
