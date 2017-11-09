#!/bin/sh

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask && brew tap caskroom/versions && brew update

brew cask install dropbox
brew cask install docker
brew cask install java 
brew cask install google-drive
brew cask install iterm2 
brew cask install caffeine 
brew cask install sequel-pro 
brew cask install virtualbox 
brew cask install vagrant 
brew cask install disk-inventory-x 
brew cask install sourcetree
brew cask install sublime-text
brew cask install slack
brew cask install intellij-idea 
brew cask install poedit 
brew cask install the-unarchiver
brew cask install caskroom/fonts/font-hack
brew cask install obs
brew cask install cathode
brew cask install dbvisualizer
brew cask install squirrelsql
brew cask install keepassx
brew install Caskroom/cask/adpassmon
brew tap pivotal/tap
brew install springboot
    
brew install coreutils z ack git wget findutils
brew install rbenv jenv nvm ansible brew-gem scala sbt
brew install readline postgres maven gradle mongodb cmake mariadb 
brew install gource ffmpeg ec2-api-tools openconnect
brew install terraform

# Optional stuff, not needed now or already installed
#brew cask install google-chrome 
#brew cask install firefox 
#brew cask install hipchat
#brew cask install citrix-receiver 

#Enable showing of hidden folders
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
