#!/bin/bash

sudo apt update
sudo apt install modular
curl https://get.modular.com | sh - && modular auth # <INSERT TOKEN>
modular install mojo
