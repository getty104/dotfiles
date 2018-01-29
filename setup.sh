#!/bin/bash -eu

read -p "ICloudにはログインしていますか？ (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac


read -p "App Storeの無料アプリのパスワードを不要にしましたか？ (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac

if ! type brew >/dev/null 2>&1; then
  echo "--------------------------------------------"
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
          openssl
          erlang
          elixir-build
          exenv
          mas
          )

echo "--------------------------------------------"
echo "installing brew formula..."
brew install ${formulas[@]}
brew services start mysql
brew services start postgresql
brew services start redis

echo "--------------------------------------------"
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

echo "--------------------------------------------"
echo "set up rbenv..."
mkdir -p "$(rbenv root)/plugins"
git clone https://github.com/znz/rbenv-plug.git "$(rbenv root)/plugins/rbenv-plug"
rbenv plug rbenv-update
rbenv plug rbenv-gem-rehash
rbenv plug rbenv-communal-gems
rbenv communize --all
rbenv rehash

apps=(
      google-chrome
      iterm2
      sequel-pro
      psequel
      gitify
      appcleaner
      java
      xquartz
      karabiner-elements
      sqlitebrowser
      docker
      vagrant
      virtualbox
      sublime-text
      skype
      amazon-music
      )

echo "--------------------------------------------"
echo "installing apps..."
brew cask install ${apps[@]}

echo "--------------------------------------------"
echo "cleanup brew cask..."
brew cask cleanup

appleapps=(
           803453959 #Slack
           539883307 #Line
           )

echo "--------------------------------------------"
echo "install aplle store apps..."
mas install ${appleapps[@]}

echo "--------------------------------------------"
echo "symbolic link of sublime text..."
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

echo "--------------------------------------------"
echo "please set up iTerm2"
echo "please set up sublime text and lisence key"
echo "setup karabiner-elements (caps-lock-to-ctrl and vim-mode)"
echo "setup chrome(vimium React Developer Tool)"
echo ""
echo "Success!"
echo "--------------------------------------------"
