#!/bin/sh

echo "Setting up MacOS (Dylan's config)"

echo "Disabling unidentified developer warning"
sudo spctl --master-disable

echo "Installing brew package manager"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Installing brew packages"
brew install node n yarn go docker

echo "Installing brew casks"
brew cask install visual-studio-code mysqlworkbench spotify eloston-chromium

# Github ssh key

echo "Do you want to generate a ssh key and use it for Github (y/n)?"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Generating RSA key"
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/gitub_rsa

    echo "Setting github.com IdentitiyFile"
    echo "Host github.com" >> ~/.ssh/config
    echo "    IdentityFile ~/.ssh/github_rsa" >> ~/.ssh/config
fi

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Configuring .zshrc"

# Delete default oh-my-zsh config
rm ~/.zshrc

# oh-my-zsh configuration
echo "plugins=(git colored-man-pages colorize pip python brew osx zsh-syntax-highlighting zsh-autosuggestions)" >> ~/.zshrc
echo "ZSH_THEME=apple" >> ~/.zshrc

# Aliases
echo "alias p=pwd" >> ~/.zshrc
echo "alias c=clear" >> ~/.zshrc
echo "alias l=ls -l" >> ~/.zshrc
echo "alias d=docker" >> ~/.zshrc
echo "alias dps=docker ps" >> ~/.zshrc
echo "alias dev=cd ~/Documents/Git/" >> ~/.zshrc

echo "Complete!"