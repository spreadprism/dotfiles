#!/bin/bash

GIT_URL="https://github.com/spreadprism/dotfiles"
DOTFILE_DIR="$HOME/.dotfiles"
BOOTSTRAP_DIR="$HOME/boot-tmp"

NEXUS_PLATFORM="" # INFO: Linux, MacOS, WSL

_PLATFORM_LINUX="Linux"
_PLATFORM_MACOS="MacOS"
_PLATFORM_WSL="WSL"

NEXUS_DISTRO=""
_DISTRO_ARCH="arch"
_DISTRO_UBUNTU="ubuntu"
_DISTRO_DEBIAN="debian"
_DISTRO_RHEL="rhel"

NEXUS_PLATFORM=$(uname -sr)
_DEPENDENCIES_PM=""
_DEPENDENCIES_LOCAL=""
NEXUS_BIN_DIR="$HOME/.bin"
export PATH="$PATH:$_DAPPER_BIN_DIR"

case "${NEXUS_PLATFORM}" in
  Darwin*)
    NEXUS_PLATFORM=$_PLATFORM_MACOS
    # TODO: Support macos, if need be
    echo "${NEXUS_PLATFORM} is not supported"
    exit 1
    ;;
  Linux*Microsoft*)
    NEXUS_PLATFORM=$_PLATFORM_WSL
    ;;
  Linux*)
    NEXUS_PLATFORM=$_PLATFORM_LINUX
    ;;
  *)
    echo "${NEXUS_PLATFORM} is not supported"
    exit 1
    ;;
esac

if [ "$NEXUS_PLATFORM" = "$_PLATFORM_LINUX" ] || [ "$NEXUS_PLATFORM" = "$_PLATFORM_WSL" ]; then
  NEXUS_DISTRO=$(cat /etc/*-release | grep -i '^ID=' | cut -d'=' -f2)
fi

_nexus_add() {
  DEPENDENCY="$1"
  CMD="$1"
  shift

  for arg in "$@"; do
    key=$(echo "$arg" | cut -d"=" -f1)
    value=$(echo "$arg" | cut -d"=" -f2)

    if [ "$key" = "cmd" ]; then
      CMD="$value"
    elif [ "$key" = "$_DISTRO" ]; then
      DEPENDENCY="$value"
    fi
  done

  if ! command -v "$CMD" &> /dev/null; then
    if [ -z "$_DEPENDENCIES_PM" ]; then
      _DEPENDENCIES_PM="$DEPENDENCY"
    else
      _DEPENDENCIES_PM="$_DEPENDENCIES_PM $DEPENDENCY"
    fi
  fi
}

# nexus_add_git() {
# TODO: Complete function
# }

_nexus_install() {
  _nexus_install_pm
  _nexus_install_git
}

_nexus_install_pm() {
  if [ ! -z $_DEPENDENCIES_PM ]; then
    case $_DISTRO in
      $_DISTRO_ARCH
        sudo pacman -S --noconfirm --needed $_DEPENDENCIES_PM
        ;;
      $_DISTRO_DEBIAN|$_DISTRO_UBUNTU)
        sudo apt-get install -y $_DEPENDENCIES_PM
        ;;
      $_DISTRO_RHEL)
        sudo dnf install -y $_DEPENDENCIES_PM
        ;;
      *)
        echo "$_DISTRO is not a supported"
        exit 1
    esac
    _DEPENDENCIES_PM=""
  fi
}

_nexus_install_git() {
  if [ ! -z $_DEPENDENCIES_PM ]; then
    _nexus_ensure_eget_installed

    # TODO: Install logic
  fi
}

_nexus_ensure_eget_installed() {
  EGET_PATH=$_DAPPER_BIN_DIR/eget
  if [ ! -f $EGET_PATH ]; then
    LAST_PWD=$PWD
    cd $BIN_DIR
    curl -sS https://zyedidia.github.io/eget.sh | sh
    cd $LAST_PWD
  fi
}

set -e

_nexus_add git
_nexus_add stow

_nexus_install

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
  nexus_add_install zsh
  rm -rf $BOOTSTRAP_DIR
  exec $(which zsh)
else
  rm -rf $BOOTSTRAP_DIR
  exec $(which bash)
fi
