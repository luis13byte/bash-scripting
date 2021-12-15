#!/bin/bash

sudo apt update && sudo apt install -y nmap net-tools yakuake colordiff htop docker.io dnsutils mysql-client postgresql-client filezilla python3 gnupg software-properties-common curl terminator jq gparted git rkhunter virtualbox vagrant
sudo snap install go --classic
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

# Kubernetes
wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
tar xf kubeval-linux-amd64.tar.gz
sudo cp kubeval /usr/local/bin
