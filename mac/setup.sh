#!/bin/bash -eu

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
echo "brew bundle..."
brew bundle
brew services start mysql
brew services start postgresql
brew services start redis

echo "----------------------------------------------------------------------------"
echo "installing zplug..."
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
ln -sf ~/dotfiles/mac/zshrc ~/.zshrc
ln -sf ~/dotfiles/vimrc ~/.vimrc
mkdir ~/.vim
ln -sf ~/dotfiles/snippets ~/.vim/snippets
mkdir ~/.zsh
cd ~/.zsh
source ~/.zshrc
git secrets --register-aws --global
git config --global credential.helper osxkeychain
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
echo "set up pyenv"
pyenv install anaconda3-5.1.0
pyenv global anaconda3-5.1.0
pyenv rehash
pip install neovim

echo "----------------------------------------------------------------------------"
echo "cleanup brew..."
brew cleanup
brew cask cleanup

echo "----------------------------------------------------------------------------"
echo "symbolic link of sublime text..."
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

echo "----------------------------------------------------------------------------"
echo "please set up iTerm2"
echo "please set up git( ssh-key, name, email ) http://monsat.hatenablog.com/entry/generating-ssh-keys-for-github"
echo "please set up sublime text and lisence key"
echo "setup karabiner-elements (caps-lock-to-ctrl and vim-mode)"
echo "setup chrome(vimium React Developer Tool)"

echo "----------------------------------------------------------------------------"
echo "Success!"
