# osxinstall
Installation script for setting up work machine with Homebrew

Here is additional trick: add this into your .zshrc etc: 

```
#easy update of brew
alias brewski='brew update && brew upgrade && brew cleanup; brew cask cleanup; brew doctor'
```

Then you can run: 

```
brewski
```

to update EVERYTHING! ;)

I also carry a bit extra stuff:

```
#rbenv
eval "$(rbenv init -)"

#nvm
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

#prefer local node
export PATH=./node_modules/.bin:$PATH
```
