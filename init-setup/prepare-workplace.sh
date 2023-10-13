#!/bin/bash
set -e # enable errexit option
set -u # enable nounset option
set -x # enable xtrace option

readonly GIT_USER="luis13byte"

installPackages() {
  sudo add-apt-repository ppa:shutter/ppa
  sudo apt-get update && sudo apt-get install -y nmap tree vlc net-tools tmux clipit colordiff htop docker.io dnsutils mysql-client postgresql-client filezilla python3 \
    gnupg software-properties-common curl jq gparted zsh git-core git rkhunter locate shutter

  # Snap Installs
  sudo snap install go --classic && 
  sudo snap install code --classic

  # Ending
  echo "export PATH=$HOME/bin:/usr/local/bin:$HOME/go/bin:$PATH" >> ~/.zshrc
  sudo mkdir -p /opt/git/${GIT_USER} /opt/tools /backup/_special ~/Bucket/ ~/Scripts/ ~/TestArea/
  sudo chown ${USER}: /opt/git
}

gitConfig() {
cat << 'EOF' > /opt/git/.gitignore_global
# Exclusiones para IDEs y herramientas
.idea/
.vscode/
.history/
EOF

  sudo chown ${USER}: /opt/git/ /backup/ -R
  git config --global core.excludesfile /opt/git/.gitignore_global
}

installAlacritty() {
  sudo add-apt-repository ppa:mmstick76/alacritty && sudo apt install alacritty -y \
    && mkdir -p $HOME/.config/alacritty/
}

# Custom tmux (Dracula Theme)
tmuxConfig() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
   && wget https://raw.githubusercontent.com/luis13byte/dotfiles/master/tmux/.tmux.conf -O ~/.tmux.conf \
   && echo "Necessary reload tmux environment. Press <prefix> + I (capital i) in tmux windows to install plugins."
}

dockerConfig() {
  sudo usermod -aG docker $USER
  sudo curl -L "https://github.com/docker/compose/releases/download/2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && sudo chmod +x /usr/local/bin/docker-compose \
    && sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
}

installKubectl() {
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && mkdir /${USER}/.kube
}

installChrome() {
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/install-chrome.deb \
    && sudo apt-get install /tmp/install-chrome.deb
}

# Run functions
installPackages
gitConfig
installAlacritty
tmuxConfig
dockerConfig
installKubectl
installChrome
