#! /bin/sh

CWD=$PWD
GIT_REPO="https://github.com/Spreadprism/dotfiles.git"
DOTFILES_LOCATION="$HOME/.dotfiles"
USR_BIN="$HOME/bin"

# Interupt if error
set -e

# Install dotfiles
if [ ! -d $DOTFILES_LOCATION ]; then
  git clone $GIT_REPO $DOTFILES_LOCATION
  clear
fi

cd $DOTFILES_LOCATION

# Only bootstrap base configs + shell configs
stow base --adopt
stow shell --adopt

# We force our config files
git clean -df
git checkout -- .

cd $CWD

BIN_DIR=$HOME/bin

if ! command -v zsh &> /dev/null; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)" -- -d $HOME/bin -e yes
  clear
  export PATH="$PATH:$BIN_DIR/bin"
fi

exec zsh
