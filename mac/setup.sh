#!/bin/zsh -eu

if ! type brew >/dev/null 2>&1; then
  echo "----------------------------------------------------------------------------"
  echo "installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "----------------------------------------------------------------------------"
echo "brew bundle..."
brew bundle

echo "----------------------------------------------------------------------------"
echo "installing zplug..."
brew install zplug

echo "----------------------------------------------------------------------------"
echo "Setup tools..."

ln -sf ~/dotfiles/mac/zshrc ~/.zshrc
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/ideavimrc ~/.ideavimrc
mkdir ~/.vim
mkdir ~/.vim/dein
ln -sf ~/dotfiles/snippets ~/.vim/snippets
ln -sf ~/dotfiles/toml ~/.vim/dein/toml
git secrets --register-aws --global
git config --global credential.helper osxkeychain
cd ~

echo "----------------------------------------------------------------------------"
echo "set up env..."
brew install anyenv
anyenv init
anyenv install rbenv
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
echo "cleanup brew..."
brew cleanup

echo "----------------------------------------------------------------------------"
echo "Update macOS settings..."
defaults write -g InitialKeyRepeat -int 11
defaults write -g KeyRepeat -int 1

echo "----------------------------------------------------------------------------"
echo "please set up iTerm2"
echo "please set up git( ssh-key, name, email ) http://monsat.hatenablog.com/entry/generating-ssh-keys-for-github"
echo "setup karabiner-elements (caps-lock-to-ctrl)"
echo "setup chrome (vimium React Developer Tool)"

echo "----------------------------------------------------------------------------"
echo "Success!"
