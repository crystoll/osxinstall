#!/bin/sh

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#brew install caskroom/cask/brew-cask && 
brew tap caskroom/versions && brew update

brew cask install docker
brew cask install java8
brew cask install java 
brew cask install caffeine 
brew cask install sequel-pro 
brew cask install virtualbox 
brew cask install vagrant 
brew cask install disk-inventory-x 
brew cask install sourcetree
brew cask install intellij-idea 
brew cask install poedit 
brew cask install the-unarchiver
brew cask install caskroom/fonts/font-hack
brew cask install obs
brew cask install cathode
brew cask install squirrelsql
brew cask install keepassxc
brew cask install avilbrazil-rdm
brew tap pivotal/tap
brew install springboot
    
brew install coreutils z ack git wget findutils
brew install rbenv jenv nvm ansible brew-gem scala sbt
brew install postgres maven gradle mongodb cmake mariadb 
brew install gource ffmpeg ec2-api-tools openconnect thefuck
brew install awscli azure-cli ctop jq

# Python goodness, to use specific python, run: 
# pyenv local 3.5.0 to create .python-version file for folder
brew install pyenv && pyenv install 3.6.5 && pyenv install 2.7.14

# Would be nice to install, but website is a bit shaky
#brew cask install keepassx

# Optional stuff, not needed now or already installed
#brew install readline
#brew install Caskroom/cask/adpassmon
#brew cask install dbvisualizer
#brew cask install slack
#brew cask install sublime-text
#brew cask install google-drive
#brew cask install iterm2 
#brew cask install dropbox
#brew cask install google-chrome 
#brew cask install firefox 
#brew cask install hipchat
#brew cask install citrix-receiver 
#brew install terraform

#Enable showing of hidden folders
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#Link sublime to command line sublime call
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime