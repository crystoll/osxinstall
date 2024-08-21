#!/bin/sh

# Get developer tools    
xcode-select --install

# Get Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Next steps
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/artosantala/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Essentials
brew install --cask iterm2 

# Here would be good to swap to iterm2

brew install --cask google-chrome firefox

# Some extra cloud services
brew install --cask google-drive 
brew install --cask dropbox

# excellent code editors
brew install --cask sublime-text visual-studio-code

# Incredible productivity tool
brew install --cask spotify

# Enable showing of hidden folders
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Containers, using colima to host
brew install colima docker
brew services start colima


#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#install python stuff
brew install pyenv
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc
pyenv install 3.12
pyenv global 3.12

#install node stuff
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 18

#install java stuff
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.4-tem

#install terraform stuff
brew install warrensbox/tap/tfswitch

# dbeaver
brew install dbeaver-community

# aws cli and session manager plugin
brew install awscli
brew install --cask session-manager-plugin
aws configure set cli_pager ""

# Setup default identity for git - can also setup --local
#git config --global user.name "<myname>"
#git config --global user.email "<myemail>"

## Optionals
# brew install --cask intellij-idea
# brew install --cask obs

