#!/bin/bash

source ./.subscripts/check_packages.sh

function apt_installation()
{
    sudo apt update -y
    sudo apt upgrade -y
    xargs -a ./.lists/apt.list sudo apt install -y
    check_packages
}

function dnf_installation()
{
      sudo dnf update
      xargs -a ./.lists/dnf.list sudo dnf install
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
                apt_installation
                ;;
            dnf)
                dnf_installation
                ;;
            pacman)
                pacman_installation
                ;;
            zypper)
                zypper_installation
                ;;
    esac
}
