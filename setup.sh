if ! type brew >/dev/null 2>&1; then
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install git
brew install zsh
brew install rbenv
brew install pyenv
brew install nodenv
brew install mysql
brew install postgresql
brew install redis
brew services start mysql
brew services start postgresql
brew services start redis

curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
cp zshrc ~/.zshrc
cd ~
mkdir .zsh
cd .zsh
git clone git://github.com/hchbaw/auto-fu.zsh.git
cd auto-fu.zsh
git checkout -b pu origin/pu
source ~/.zshrc
