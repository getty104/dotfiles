#!/bin/zsh -eu

echo "----------------------------------------------------------------------------"
echo "Accept xcode license..."
sudo xcodebuild -license accept
echo "----------------------------------------------------------------------------"

if ! type brew >/dev/null 2>&1; then
  echo "----------------------------------------------------------------------------"
  echo "installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "----------------------------------------------------------------------------"
echo "brew bundle..."
brew bundle

echo "----------------------------------------------------------------------------"

echo "Setup tools..."
ln -sf ~/dotfiles/mac/zshrc ~/.zshrc

ln -sf ~/dotfiles/vimrc ~/.vimrc
mkdir -p ~/.vim/dein
ln -sf ~/dotfiles/nvim/toml ~/.vim/dein/toml

mkdir -p ~/.config
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/wezterm ~/.config/wezterm

mkdir -p ~/.hammerspoon
ln -sf ~/dotfiles/hammerspoon ~/.hammerspoon

mkdir -p ~/.claude
ln -sf ~/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/dotfiles/claude/commands ~/.claude/commands

git secrets --register-aws --global
git config --global credential.helper osxkeychain
cd ~

echo "----------------------------------------------------------------------------"
echo "set up env..."
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
echo "setup chrome (vimium, React Developer Tool)"

echo "----------------------------------------------------------------------------"
echo "Success!"
