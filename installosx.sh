#!/bin/sh

ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
brew update && brew install caskroom/cask/brew-cask && brew tap caskroom/versions
brew cask install dropbox 
   
brew cask install java 
brew cask install google-chrome 
brew cask install firefox 
brew cask install google-drive
brew cask install iterm2 
brew cask install caffeine 
brew cask install sequel-pro 
brew cask install virtualbox 
brew cask install vagrant 
brew cask install disk-inventory-x 
brew cask install sourcetree
    
brew cask install sublime-text3 
brew cask install hipchat
brew cask install balsamiq-mockups 
brew cask install intellij-idea 
brew cask install citrix-receiver 
brew cask install dockertoolbox 
brew cask install poedit 
brew cask install the-unarchiver
    
brew install coreutils 
brew install z 
brew install ack 
brew install git 
brew install curl 
brew install wget 
brew install findutils
brew install zsh 
brew install zsh-completions
brew install readline 
brew install findutils postgres 
brew install findutils maven 
brew install findutils gradle 
brew install mongodb 
brew install findutils cmake 
brew install findutils mariadb 
brew install findutils jenv 
brew install findutils nvm 
brew install findutils ansible

