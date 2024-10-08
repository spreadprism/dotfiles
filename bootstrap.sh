#!/bin/sh
set -e

GIT_URL="https://github.com/spreadprism/dotfiles"
DOTFILE_DIR="$HOME/.dotfiles"
BOOTSTRAP_DIR="$HOME/boot-tmp"

source_util () {
  if [ -d $DOTFILE_DIR ]; then
    source $DOTFILE_DIR/$1
  else
    curl -s -o $BOOTSTRAP_DIR/script.sh https://raw.githubusercontent.com/spreadprism/dotfiles/main/$1
    chmod +x $BOOTSTRAP_DIR/script.sh
    source $BOOTSTRAP_DIR/script.sh
  fi
}

echo "Bootstrap"

source_util dapper.sh

dapper_add git
dapper_add stow
dapper_install

if [ ! -d $DOTFILE_DIR ]; then
  git clone $GIT_URL $DOTFILE_DIR --recurse-submodules
  clear
fi

cd $DOTFILE_DIR

stow base
stow shell

USE_ZSH=false

for arg in "$@"; do
  case $arg in
    --zsh)
      USE_ZSH=true
      ;;
  esac
done

if $USE_ZSH; then
  dapper_add_install zsh
  rm -rf $BOOTSTRAP_DIR
  exec $(which zsh)
else
  rm -rf $BOOTSTRAP_DIR
  exec $(which bash)
fi
