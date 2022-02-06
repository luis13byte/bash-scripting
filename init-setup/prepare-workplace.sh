#!/bin/bash

sudo apt update && sudo apt install -y nmap tree net-tools tmux yakuake colordiff htop docker.io dnsutils mysql-client postgresql-client filezilla python3 gnupg software-properties-common curl jq gparted zsh git-core git rkhunter virtualbox locate vagrant
sudo snap install go --classic && echo "export PATH=$HOME/bin:/usr/local/bin:$HOME/go/bin:$PATH" >> ~/.zshrc
mkdir ~/Bucket/ ~/Docker/ ~/Scripts/ ~/TestArea/
sudo mkdir -p /opt/git/luis13byte /opt/tools /opt/vagrant/ /backup/_special
sudo chown ${USER}: /opt/git

# Git config
cat << EOF > /opt/git/.gitignore_global
# IDEs
.idea/
.vscode/
.history/
EOF

sudo chown ${USER}: /opt/git/ /opt/vagrant/ /backup/ -R
git config --global core.excludesfile /opt/git/.gitignore_global

# Install Alacritty
sudo add-apt-repository ppa:mmstick76/alacritty && sudo apt install alacritty -y \
&& mkdir -p $HOME/.config/alacritty/

# Custom tmux (Dracula Theme)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
&& wget https://raw.githubusercontent.com/luis13byte/dotfiles/master/tmux/.tmux.conf -O ~/.tmux.conf \
&& echo "Necessary reload tmux environment. Press <prefix> + I (capital i) in tmux windows to install plugins."

# Config docker and install docker-compose
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
&& sudo chmod +x /usr/local/bin/docker-compose \
&& sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Kubeval tool
wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
tar xf kubeval-linux-amd64.tar.gz
sudo cp kubeval /usr/local/bin

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/install-chrome.deb \
&& sudo apt install /tmp/install-chrome.deb

# Install Podman
source /etc/os-release
sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O- | apt-key add -
sudo apt update -qq && sudo apt-get -qq --yes install podman
