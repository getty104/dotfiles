#!/bin/bash -eu

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
          goenv
          mas
          )

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

appleapps=(
           803453959 #Slack
           539883307 #Line
           497799835 #XCode
           )

read -p "dotfilesは~/に置かれていますか？ (y/N): " yn0
case "$yn0" in [yY]*) ;; *) echo "abort." ; exit ;; esac

read -p "ICloudにはログインしていますか？ (y/N): " yn1
case "$yn1" in [yY]*) ;; *) echo "abort." ; exit ;; esac

read -p "App Storeの無料アプリのパスワードを不要にしましたか？ (y/N): " yn2
case "$yn2" in [yY]*) ;; *) echo "abort." ; exit ;; esac

if ! type brew >/dev/null 2>&1; then
  echo "----------------------------------------------------------------------------"
  echo "installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "----------------------------------------------------------------------------"
echo "installing brew formula..."
brew install ${formulas[@]}
brew services start mysql
brew services start postgresql
brew services start redis

echo "----------------------------------------------------------------------------"
echo "installing oh-my-zsh..."
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
ln -sf ~/dotfiles/zshrc ~/.zshrc
mkdir ~/.zsh
cd ~/.zsh
git clone git://github.com/hchbaw/auto-fu.zsh.git
cd auto-fu.zsh
git checkout -b pu origin/pu
source ~/.zshrc
git secrets --register-aws --global
cd ~

echo "----------------------------------------------------------------------------"
echo "set up rbenv..."
mkdir -p "$(rbenv root)/plugins"
git clone https://github.com/znz/rbenv-plug.git "$(rbenv root)/plugins/rbenv-plug"
rbenv plug rbenv-update
rbenv plug rbenv-gem-rehash
rbenv plug rbenv-communal-gems
rbenv communize --all
rbenv rehash


echo "----------------------------------------------------------------------------"
echo "installing apps..."
brew cask install ${apps[@]}

echo "----------------------------------------------------------------------------"
echo "cleanup brew cask..."
brew cask cleanup

echo "----------------------------------------------------------------------------"
echo "install aplle store apps..."
mas install ${appleapps[@]}

echo "----------------------------------------------------------------------------"
echo "symbolic link of sublime text..."
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

echo "----------------------------------------------------------------------------"
echo "please set up iTerm2"
echo "please set up sublime text and lisence key"
echo "setup karabiner-elements (caps-lock-to-ctrl and vim-mode)"
echo "setup chrome(vimium React Developer Tool)"

echo "----------------------------------------------------------------------------"
echo "Success!"
