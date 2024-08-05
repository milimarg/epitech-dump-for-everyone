#!/bin/bash

source ./.subscripts/get_packet_manager.sh
source ./.subscripts/install_needed_packages.sh

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
         3 "Install criterion" off
         4 "Install raylib (tek2)" off
         5 "Download coding style checker" off
         6 "Generate SSH key for github" off)

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
              install_needed_packages "$found_package_manager"
              ;;
          2)
              echo "Vous avez choisi l'Option 2"
              ;;
          3)
              echo "Vous avez choisi l'Option 3"
              ;;
          4)
              echo "Vous avez choisi l'Option 4"
              ;;
          5)

              ;;
          6)

              ;;
  esac
done
