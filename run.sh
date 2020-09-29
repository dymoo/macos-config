#!/bin/sh
# Read the README.md

log() {
    red=`tput setaf 1`
    green=`tput setaf 2`
    reset=`tput sgr0`
    
    if [ -z "$2" ]; then
        echo "${green}[info] ${1}${reset}"
    else
        echo "${red}[error] ${1}${reset}"
    fi
}

if [ "$EUID" -eq 0 ]; then
    log "Do not run this script as sudo! (~/ used)" 1
    exit
fi

log "Setup has started..."

#################### MacOS modifications ####################

log "Disabling unidentified developer warning"
sudo spctl --master-disable

#################### Package management ####################

log "Installing brew package manager"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

log "Installing brew packages"
brew install node n yarn go docker tmux

log "Installing brew casks"
brew cask install visual-studio-code mysqlworkbench spotify eloston-chromium transmission

#################### Github SSH key generation ####################

log "Do you want to generate a ssh key and use it for Github (y/n)?"
read sshkeyanswer

if [ "$sshkeyanswer" != "${sshkeyanswer#[Yy]}" ]; then
    log "Generating RSA key"
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_rsa

    log "Setting github.com IdentitiyFile"
    echo "Host github.com" >> ~/.ssh/config
    echo "    IdentityFile ~/.ssh/github_rsa" >> ~/.ssh/config

    log "Copy your public RSA key"
    cat ~/.ssh/github_rsa.pub
    log "Press any key to continue..."
    read
else
    log "Skipping..."
fi

#################### Terminal configuration ####################

log "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

log "Configuring ~/.zshrc"

# Delete default oh-my-zsh config
rm ~/.zshrc

# Spawn tmux
echo "if [ \"$TMUX\" = \"\" ]; then tmux; fi" >> ~/.zshrc

# oh-my-zsh configuration
echo "plugins=(git colored-man-pages colorize pip python brew osx zsh-syntax-highlighting zsh-autosuggestions)" >> ~/.zshrc
echo "ZSH_THEME=apple" >> ~/.zshrc

# Aliases
echo "alias python=python3" >> ~/.zshrc
echo "alias pip=pip3" >> ~/.zshrc
echo "alias v=vim" >> ~/.zshrc
echo "alias p=pwd" >> ~/.zshrc
echo "alias c=clear" >> ~/.zshrc
echo "alias l=\"ls -l\"" >> ~/.zshrc
echo "alias d=docker" >> ~/.zshrc
echo "alias dps=\"docker ps\"" >> ~/.zshrc
echo "alias dev=\"cd ~/Documents/Git/\"" >> ~/.zshrc

#################### Cleanup / complete ####################

log "Complete!"