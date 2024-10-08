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
_DEPENDENCIES=""

case "${_PLATFORM}" in
  Darwin*)
    _PLATFORM=$_PLATFORM_MACOS
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

dapper_add () {
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
    echo "adding $DEPENDENCY"
    if [ -z "$_DEPENDENCIES" ]; then
      _DEPENDENCIES="$DEPENDENCY"
    else
      _DEPENDENCIES="$_DEPENDENCIES $DEPENDENCY"
    fi
  fi
}

dapper_install () {

  if [ ! -z $_DEPENDENCIES ]; then
    case $_DISTRO in
      $_DISTRO_ARCH)
        sudo pacman -S --noconfirm --needed $_DEPENDENCIES
        ;;
      $_DISTRO_DEBIAN|$_DISTRO_UBUNTU)
        sudo apt-get install -y $_DEPENDENCIES
        ;;
      $_DISTRO_RHEL)
        sudo dnf install -y $_DEPENDENCIES
        ;;
      *)
        echo "$_DISTRO is not a supported"
        exit 1
    esac
    _DEPENDENCIES=""
  fi
}
