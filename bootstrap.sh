#!/bin/sh

GIT_URL="https://github.com/spreadprism/dotfiles"
DOTFILE_DIR="$HOME/.dotfiles"

function source_util {
  if [ -d $DOTFILE_DIR ]; then
    source $DOTFILE_DIR/$1
  else
    source <(curl -s https://raw.githubusercontent.com/spreadprism/dotfiles/main/$1)
  fi
}


source_util dapper.sh

dapper_add git
dapper_add stow
dapper_install

if [ ! -d $DOTFILE_DIR ]; then
  git clone $GIT_URL $DOTFILE_DIR --recurse-submodules
  clear
fi

cd $DOTFILE_DIR

stow shell --adopt
