#!/bin/sh

# Get developer tools    
xcode-select --install

# Get Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Essentials
brew install --cask iterm2 
brew install --cask google-chrome firefox
brew install --cask docker

# Some extra cloud services
brew install --cask google-drive 
brew install --cask dropbox

# excellent code editors
brew install --cask sublime-text visual-studio-code
brew install --cask intellij-idea

# Teh Best Font
brew install --cask homebrew/cask-fonts/font-hack

# Excellent screen recording tool
brew install --cask obs

# Collaboration
brew install --cask microsoft-teams slack

# Incredible productivity tool
brew install --cask spotify

#Enable showing of hidden folders
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#install python stuff
brew install pyenv
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc
pyenv install 3.9.4
pyenv global 3.9.4

#install node stuff
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

#install java stuff
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 16.0.1.hs-adpt

#install terraform stuff
brew install warrensbox/tap/tfswitch

