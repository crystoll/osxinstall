#!/bin/sh

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Fix error: zipimport.ZipImportError: can't decompress data; zlib not available
xcode-select --install
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /




brew tap caskroom/versions && brew update

brew cask install sublime-text

brew cask install google-drive-file-stream

brew cask install docker

brew cask install java 

# Teh Best Font
brew cask install caskroom/fonts/font-hack

# Excellent screen recording tool
brew cask install obs

# sql client
brew cask install squirrelsql

# excellent code editors
brew cask install intellij-idea 
brew cask install visual-studio-code

# Cool terminal apps
brew cask install iterm2 cathode
brew cask install dropbox
brew cask install google-chrome firefox

# Incredible productivity tool
brew cask install spotify


brew install terraform awscli azure-cli
brew install jq git wget findutils coreutils
brew install rbenv jenv nvm 
brew install ansible brew-gem
brew install maven gradle 
brew install gource ffmpeg thefuck


# Python versions via pyenv
# To use specific python, run: 
# pyenv local 3.5.0 to create .python-version file for folder

brew install pyenv
pyenv install 3.7.3

# Or CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" pyenv install -v 3.7.0

#Enable showing of hidden folders
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#Link sublime to command line sublime call
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime



