#!/bin/bash

# Setup brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /Users/rwx788/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/rwx788/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install tools for gpg agent configuration
brew install oh-my-zsh
brew install tmux
brew install pinentry
brew install gpg
brew install vim
brew install wget
brew install iproute2mac
brew install htop

brew install amethyst

# Install powerlevel theme for zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
