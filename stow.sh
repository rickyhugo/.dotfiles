#!/usr/bin/env bash

cd config || exit
stow --verbose --target="$HOME" --restow -- */
