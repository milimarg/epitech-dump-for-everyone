#!/bin/bash

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
