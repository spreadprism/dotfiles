#!/bin/sh

_PLATFORM="" # INFO: Linux, MacOS, WSL

_PLATFORM_LINUX="Linux"
_PLATFORM_MACOS="MacOS"
_PLATFORM_WSL="WSL"

_DISTRO=""
_DISTRO_ARCH="arch"
_DISTRO_UBUNTU="ubuntu"
_DISTRO_DEBIAN="debian"
_DISTRO_RHEL="rhel"

_PLATFORM=$(uname -sr)
_DEPENDENCIES_PM=""
_DEPENDENCIES_LOCAL=""
_DAPPER_BIN_DIR="$HOME/.bin"
export PATH="$PATH:$_DAPPER_BIN_DIR"

case "${_PLATFORM}" in
  Darwin*)
    _PLATFORM=$_PLATFORM_MACOS
    # TODO: Support macos, if need be
    echo "${_PLATFORM} is not supported"
    exit 1
    ;;
  Linux*Microsoft*)
    _PLATFORM=$_PLATFORM_WSL
    ;;
  Linux*)
    _PLATFORM=$_PLATFORM_LINUX
    ;;
  *)
    echo "${_PLATFORM} is not supported"
    exit 1
    ;;
esac

if [ "$_PLATFORM" = "$_PLATFORM_LINUX" ] || [ "$_PLATFORM" = "$_PLATFORM_WSL" ]; then
  _DISTRO=$(cat /etc/*-release | grep -i '^ID=' | cut -d'=' -f2)
fi

dapper_add() {
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
# dapper_add_git() {
#
# }

dapper_add_install() {
  dapper_add $@
  dapper_install
}

dapper_install() {
  _dapper_install_pm
  _dapper_install_git
}

_dapper_install_pm() {
  if [ ! -z $_DEPENDENCIES_PM ]; then
    case $_DISTRO in
      $_DISTRO_ARCH)
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

_dapper_install_git() {
  if [ ! -z $_DEPENDENCIES_PM ]; then
    _dapper_ensure_eget_installed

    # TODO: Install logic
  fi
}

_dapper_ensure_eget_installed() {
  EGET_PATH=$_DAPPER_BIN_DIR/eget
  if [ ! -f $EGET_PATH ]; then
    LAST_PWD=$PWD
    cd $BIN_DIR
    curl -sS https://zyedidia.github.io/eget.sh | sh
    cd $LAST_PWD
  fi
}
