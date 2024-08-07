#!/bin/bash

source ./.subscripts/get_packet_manager.sh
source ./.subscripts/install_needed_packages.sh
source ./.subscripts/add_emacs_configuration.sh
source ./.subscripts/install_raylib.sh

check_if_sudo_is_installed
found_package_manager=$?

#TODO: merge 2 arrays "package_managers"

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
