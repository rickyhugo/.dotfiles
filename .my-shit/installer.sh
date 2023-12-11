#!/bin/bash

# misc
MY_GITIGNORE=~/.my-shit/.gitignore
MY_ALIASES=~/.my-shit/aliases.sh
touch "$MY_GITIGNORE" "$MY_ALIASES"
chmod u+x "$MY_GITIGNORE" "$MY_ALIASES"

function add_omz_plugin {
    sed -i "/^plugins=(/,/)/ s/)$/\n\t$1\n)/" ~/.zshrc
}

# neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
echo "alias vim=nvim" >> "$MY_ALIASES"

# kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
sudo ln -s ~/.local/kitty.app/bin/kitty /usr/local/bin/kitty
kitty +kitten themes catppuccin-mocha
printf '\n# hot stuff' >> ~/.config/kitty/kitty.conf
echo 'window_padding_width 5 10' >> ~/.config/kitty/kitty.conf
echo 'font_size 10' >> ~/.config/kitty/kitty.conf

# packages
sudo apt update

# i3
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2023.02.18_all.deb keyring.deb SHA256:a511ac5f10cd811f8a4ca44d665f2fa1add7a9f09bef238cdfad8461f5239cc4
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo apt install i3

# git
sudo apt install git-all -y
git config --global core.excludesfile "$MY_GITIGNORE"

# xclip
sudo apt install xclip -y

# zsh
sudo apt install zsh -y
chsh -s "$(which zsh)" # NOTE: logout required
echo "$SHELL"
"$SHELL" --version
printf '\n# misc' >> ~/.zshrc
echo "PATH=$PATH:~/.local/bin" >> ~/.zshrc

# font
curl -sL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz | sudo tar xf - -J -C /usr/share/fonts/
rm FiraCode.tar.xz
echo 'font_family FiraCode Nerd Font Mono' >> ~/.config/kitty/kitty.conf

# omz
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
touch ~/.oh-my-zsh/custom/aliases.zsh
echo ". $MY_ALIASES" >> ~/.oh-my-zsh/custom/aliases.zsh

# omz plugins
git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH_CUSTOM"/plugins/zsh-vi-mode # zsh-vi-mode
add_omz_plugin zsh-vi-mode

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting # zsh-syntax-highlighting
add_omz_plugin zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions # zsh-autosuggestions
add_omz_plugin zsh-autosuggestions

git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "$ZSH_CUSTOM"/plugins/autoupdate # autoupdate
add_omz_plugin autoupdate

git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/fzf-zsh-plugin # fzf-zsh-plugin
add_omz_plugin fzf-zsh-plugin

git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/fzf-tab # fzf-tab
add_omz_plugin fzf-tab

# p10k
# NOTE: "lean" theme, 8 colors
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
sed -i "s|^ZSH_THEME=.*|ZSH_THEME=powerlevel10k/powerlevel10k|" .zshrc

# z-around
git clone https://github.com/rupa/z.git z-around
printf '\n# z-around' >> ~/.zshrc
echo '. ~/z-around/z.sh' >> ~/.zshrc

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
add_omz_plugin fzf
printf '%c' "message" '\n# fzf' >> ~/.zshrc
echo 'export FZF_PREVIEW_ADVANCED=true' >> ~/.zshrc

# exa
sudo apt install exa -y

# bat
sudo apt install bat -y
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

# tmux
sudo apt install tmux -y
add_omz_plugin tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
# NOTE: press '<C-t>+I' to install plugins

# direnv
sudo apt install direnv -y
add_omz_plugin direnv
echo '.envrc' >> "$MY_GITIGNORE"

# ripgrep
sudo apt install ripgrep -y

# docker START
# docs: https://docs.docker.com/engine/install/ubuntu/
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove "$pkg"; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# NOTE: healtcheck 'sudo docker run hello-world'

# postinstall linux docs: https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker
# docker END

# lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
echo 'alias lzd=lazydocker' >> "$MY_ALIASES"

# pyenv
sudo apt-get install build-essential -y
curl https://pyenv.run | bash
prinf '\n# pyenv' >> ~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
# NOTE: https://github.com/pyenv/pyenv/issues/950
sudo apt install --no-install-recommends -y \
    libssl-dev \
    ncurses-dev \
    libffi-dev \
    libreadline-dev \
    sqlite3 libsqlite3-dev \
    tk-dev \
    bzip2 libbz2-dev \
    zlib1g-dev \
    lzma liblzma-dev
. ~/.zshrc
PYTHON_VERSION=3.10
pyenv install "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"
python -m pip install -U pip
# NOTE: neovim venv
pyenv virtualenv "$PYTHON_VERSION" neovim
pyenv activate neovim
python -m pip install -U pip
pip install --no-cache-dir -U pynvim

# pipx
# NOTE: ensure below is run with python from pyenv, not system
python -m pip install --user pipx
python -m pipx ensurepath

# pdm
pipx install pdm
mkdir "$ZSH_CUSTOM"/plugins/pdm
pdm completion zsh > "$ZSH_CUSTOM"/plugins/pdm/_pdm
add_omz_plugin pdm

# node (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
. ~/.zshrc
nvm install --lts

# pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm install -g neovim

# gh cli
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

# chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# modular:mojo
sudo apt install modular
curl https://get.modular.com | sh - && modular auth # <INSERT TOKEN>
modular install mojo

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# lua
sudo apt install lua5.4 -y
sudo apt install liblua5.4-dev -y

# luarocks
wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz
tar zxpf luarocks-3.9.2.tar.gz
cd luarocks-3.9.2 || echo "luarocks dir not found"
./configure && make && sudo make install
sudo luarocks install luasocket
rm luarocks-3.92.tar.gz

# spotify-client
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

# spotify-tui
cargo install spotify-tui

# spotifyd
sudo apt install libssl-dev libasound2-dev -y
cargo install spotifyd --locked

# control backlight laptop
sudo usermod -aG video "$USER" # NOTE: reboot required
sudo apt install brightnessctl -y

# clean
sudo apt clean
sudo apt autoremove

# reboot
sudo reboot
