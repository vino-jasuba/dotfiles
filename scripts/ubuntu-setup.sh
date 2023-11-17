#!/usr/bin/env sh

sudo apt -y update && sudo apt -y upgrade

sudo apt -y install \
    cargo \
    python3-neovim \
    git \
    kitty \
    zsh \
    g++ \
    lua-devel \
    luarocks \
    php \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    fzf \
    httpie \
    ripgrep \
    tmux \
    ruby \
    python3 \
    htop \
    lm_sensors \
    lolcat

pip3 install gitlint

sudo luarocks install luacheck

cargo install stylua

# Composer
./install-composer.sh
composer global require laravel/installer

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install node

# Docker setup
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker

echo "Don't forget to copy over your .ssh and .gnupg directories!"
