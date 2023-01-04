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

echo "----------------------------------------------------------------------------"
echo "installing zplug..."
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh
ln -sf ~/dotfiles/mac/zshrc ~/.zshrc
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/ideavimrc ~/.ideavimrc
git clone https://github.com/riywo/anyenv ~/.anyenv
mkdir ~/.vim
mkdir ~/.vim/dein
ln -sf ~/dotfiles/snippets ~/.vim/snippets
ln -sf ~/dotfiles/toml ~/.vim/dein/toml
mkdir ~/.zsh
cd ~/.zsh
git clone git://github.com/hchbaw/auto-fu.zsh.git
cd auto-fu.zsh
git checkout -b pu origin/pu
source ~/.zshrc
git secrets --register-aws --global
git config --global credential.helper osxkeychain
cd ~

echo "----------------------------------------------------------------------------"
echo "set up env..."
anyenv install rbenv
anyenv install pyenv
source ~/.zshrc

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

echo "----------------------------------------------------------------------------"
echo "please set up iTerm2"
echo "please set up git( ssh-key, name, email ) http://monsat.hatenablog.com/entry/generating-ssh-keys-for-github"
echo "setup karabiner-elements (caps-lock-to-ctrl)"
echo "setup chrome (vimium React Developer Tool)"

echo "----------------------------------------------------------------------------"
echo "Success!"
