#!/bin/bash

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
    xargs -a ./.lists/apt.list sudo apt install -y
    check_packages
    # DOCKER
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
}

function dnf_installation()
{
      sudo dnf update
      xargs -a ./.lists/dnf.list sudo dnf install
      check_packages
      # TODO: install docker
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

function run_external_installation()
{
    # CONFIG EMACS EPITECH
    git clone https://github.com/Epitech/epitech-emacs.git
    cd epitech-emacs || (echo "Couldn't clone epitech emacs configuration..." ; exit 1)
    ./INSTALL.sh local
    cd .. && rm -rf epitech-emacs
    # CRITERION --- TO DO
    # Raylib
    git clone https://github.com/raysan5/raylib.git raylib
    cd raylib/src/ || (echo "Couldn't clone raylib repository..."; exit 1)
    make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED
    sudo make install RAYLIB_LIBTYPE=SHARED
    cd ../../ && rm -rf raylib
}

function installation_manager() {
    echo "package manager found: $1!"
    if [[ $1 = "apt" ]]; then
        apt_installation
    elif [[ $1 = "dnf" ]]; then
        dnf_installation
    elif [[ $1 = "pacman" ]]; then
        pacman_installation
    elif [[ $1 = "zypper" ]]; then
        zypper_installation
    fi
}

# Get package manager name
package_managers=("apt" "dnf" "pacman" "zypper")
has_found=0
package_manager_found=""
for element in "${package_managers[@]}"; do
    type "$element" &> /dev/null
    if [[ "$?" -eq 0 ]]; then
        has_found=1
        package_manager_found=$element
        break
    fi
done

# Run commands depending of the package manager
if [[ has_found -eq 1 ]]; then
    type "sudo" &> /dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "sudo is not installed."
        echo "run this script as root, either install sudo or by using su."
        exit 1
    fi
    installation_manager "$package_manager_found"
    run_external_installation "$package_manager_found"
else
    echo "Couldn't find any known package manager..."
fi
