#!/bin/bash -eu

if ! type brew >/dev/null 2>&1; then
  echo "installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

formulas=(
          git
          git-secrets
          zsh
          rbenv
          pyenv
          nodenv
          mysql
          postgresql
          redis
          gcc
          rmtrash
          )

echo "installing brew formula..."
brew install ${formulas[@]}
brew services start mysql
brew services start postgresql
brew services start redis

echo "installing oh-my-zsh..."
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
cp zshrc ~/.zshrc
mkdir ~/.zsh
cd ~/.zsh
git clone git://github.com/hchbaw/auto-fu.zsh.git
cd auto-fu.zsh
git checkout -b pu origin/pu
source ~/.zshrc
git secrets --register-aws --global
cd ~

echo "set up rbenv..."
mkdir -p "$(rbenv root)/plugins"
git clone https://github.com/znz/rbenv-plug.git "$(rbenv root)/plugins/rbenv-plug"
rbenv plug rbenv-update
rbenv plug rbenv-gem-rehash
rbenv plug rbenv-communal-gems
rbenv communize --all

apps=(
      google-chrome
      iterm2
      sequel-pro
      psequel
      sqlitebrowser
      docker
      vagrant
      virtualbox
      sublime-text
      skype
      box-sync
      )

echo "installing apps..."
brew cask install ${apps[@]}

echo "cleanup brew cask..."
brew cask cleanup

echo "symbolic link of sublime text..."
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

echo "please install Line.app Slack.app"
echo "please download sophos from https://waseda.app.box.com/v/sophos/file/207152874157"
echo "read pdf and set up sophos"
echo "please set up iTerm2"
echo "please set up sublime text and lisence key"
