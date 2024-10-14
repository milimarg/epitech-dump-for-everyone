#!/bin/bash

# FUNCTIONS

function check_packages()
{
  if [[ "$?" -ne 0 ]]; then
    echo "Failed to install packages"
    exit 1
  fi
}

function apt_installation()
{
    sudo apt update -y
    sudo apt upgrade -y
    if [ "$1" -ne 0 ]; then
        xargs -a ./.lists/apt_raylib_dependencies.list sudo apt install -y
    else
        xargs -a ./.lists/apt.list sudo apt install -y
    fi
    check_packages
}

function dnf_installation()
{
      sudo dnf -y update
      if [ "$1" -ne 0 ]; then
          xargs -a ./.lists/dnf_raylib_dependencies.list sudo dnf -y install
      else
          xargs -a ./.lists/dnf.list sudo dnf -y install
      fi
      check_packages
}

function pacman_installation()
{
    sudo pacman -Syyu
    xargs -a ./.lists/pacman.list sudo pacman -Sy --needed
    check_packages
}

function zypper_installation()
{
    sudo zypper ref
    sudo zypper update
    xargs -a ./.lists/zypper.list sudo zypper install -y
    check_packages
    # docker
    id=$(grep -E "^ID=" /etc/os-release)
    if [[ $id == "ID=\"opensuse-tumbleweed\"" ]]; then
        zypper install -y docker docker-compose docker-compose-switch
    fi
    if [[ $id == "ID=\"opensuse-leap\"" ]]; then
        zypper addrepo https://download.opensuse.org/repositories/devel:languages:python/15.5/devel:languages:python.repo
        zypper refresh
        zypper install -y docker python3-docker-compose
    fi
}

function install_needed_packages() {
  package_managers=("pacman" "dnf" "apt" "zypper")
  case "${package_managers[$1]}" in
            apt)
                apt_installation "$2"
                ;;
            dnf)
                dnf_installation "$2"
                ;;
            pacman)
                pacman_installation "$2"
                ;;
            zypper)
                zypper_installation "$2"
                ;;
    esac
}

function add_emacs_configuration() {
  git clone https://github.com/Epitech/epitech-emacs.git
  cd epitech-emacs || (echo "Couldn't clone epitech emacs configuration..." ; exit 1)
  ./INSTALL.sh local
  cd .. && rm -rf epitech-emacs
}

function get_packet_manager() {
  package_managers=("pacman" "dnf" "apt" "zypper")
  index=0
  for element in "${package_managers[@]}"; do
      type "$element" &> /dev/null
      if [[ "$?" -eq 0 ]]; then
          return "$index"
      fi
      ((index++))
  done
  return 42
}

function check_if_sudo_is_installed() {
  get_packet_manager
  found_package_manager="$?"
  if [[ "$found_package_manager" -ne 42 ]]; then
        type "sudo" &> /dev/null
        if [[ "$?" -ne 0 ]]; then
            echo "sudo is not installed."
            echo "run this script as root, either install sudo or by using su root."
            exit 1
        fi
        return "$found_package_manager"
    else
        echo "Couldn't find any known package manager..."
        exit 1
    fi
}

function install_raylib() {
  install_needed_packages "$1" 1
  git clone --depth=1 https://github.com/raysan5/raylib.git raylib
  cd raylib/src/ || (echo "Couldn't clone raylib repository..."; exit 1)
  make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED
  sudo make install RAYLIB_LIBTYPE=SHARED
  cd ../../ && rm -rf raylib
}

# MAIN CODE

check_if_sudo_is_installed
found_package_manager=$?

HEIGHT=15
WIDTH=50
CHOICE_HEIGHT=4
BACKTITLE="Epitech dump for everyone"
MENU="Choose what to install (space):"

OPTIONS=(1 "Install needed packages" off
         2 "Add emacs configuration (tek1)" off
         3 "Install criterion [TODO]" off
         4 "Install raylib (tek2)" off
         5 "Download coding style checker [TODO]" off
         6 "Generate SSH key for github [TODO]" off)

type dialog &> /dev/null

if [ $? -ne 0 ]; then
  echo "dialog is not installed. Please install it and then run this script."
  exit 1
fi

CHOICES=$(dialog --clear \
                 --backtitle "$BACKTITLE" \
                 --checklist "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 > /dev/tty)

clear

if [ -z "$CHOICES" ]; then
  echo "No changes were made"
  exit 0
fi

IFS=' ' read -r -a selected_choices <<< "$CHOICES"

for choice in "${selected_choices[@]}"; do
  case "$choice" in
          1)
              install_needed_packages "$found_package_manager" 0
              ;;
          2)
              add_emacs_configuration
              ;;
          3)
              #TODO: install criterion from sources
              ;;
          4)
              install_raylib "$found_package_manager"
              ;;
          5)
              #TODO: install coding style checker
              ;;
          6)
              #TODO: generate ssh key and copy public key in clipboard with xclip
              ;;
  esac
done
