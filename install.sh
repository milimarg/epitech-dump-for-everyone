#!/bin/bash

function apt_installation()
{
    sudo apt update -qq
    sudo apt upgrade -yqq
    xargs -a ./.lists/apt.list sudo apt install -y
    # docker
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      \"$(. /etc/os-release && echo "$VERSION_CODENAME")\" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -yqq
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function pacman_installation()
{
    sudo pacman -Syyu
    xargs -a ./.lists/pacman.list sudo pacman -Sy --needed
}

function zypper_installation()
{
    sudo zypper ref
    sudo zypper update
    xargs -a ./.lists/zypper.list sudo zypper install -y
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

function brew_installation()
{
    brew update
    brew upgrade
    xargs -a ./.lists/brew.list brew install
}

function run_external_installation()
{
    # CONFIG EMACS
    git clone https://github.com/Epitech/epitech-emacs.git
    cd epitech-emacs || (echo "Couldn't clone epitech emacs configuration..." ; exit 1)
    ./INSTALL.sh local
    cd .. && rm -rf epitech-emacs
}

function installation_manager() {
    echo "package manager found: $1!"
    if [[ $1 = "apt" ]]; then
        apt_installation
    elif [[ $1 = "dnf" ]]; then
        echo "Head over to https://github.com/Epitech/dump to install the dump."
    elif [[ $1 = "pacman" ]]; then
        pacman_installation
    elif [[ $1 = "zypper" ]]; then
        zypper_installation
    elif [[ $1 = "brew" ]]; then
        brew_installation
    fi
}

# Get package manager name
package_managers=("brew" "apt" "dnf" "pacman" "zypper")
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
    run_external_installation
else
    echo "Couldn't find any known package manager..."
fi
