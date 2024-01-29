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
    sudo apt update -yqq
    sudo apt upgrade -yqq
    xargs -a ./.lists/apt.list sudo apt install -y
    check_packages
    # docker
    sudo install -m 0755 -d /etc/apt/keyrings
    id=$(. /etc/os-release && echo "$ID")
    if [ "$id" != "ubuntu" ] && [ "$id" != "debian" ]; then
      id=$(. /etc/os-release && echo "$ID_LIKE" | cut -d " " -f 1)
    fi
    curl -fsSL https://download.docker.com/linux/"$id"/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$id \
      \"$(. /etc/os-release && echo "$VERSION_CODENAME")\" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -yqq
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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
    # CONFIG EMACS
    git clone https://github.com/Epitech/epitech-emacs.git
    cd epitech-emacs || (echo "Couldn't clone epitech emacs configuration..." ; exit 1)
    ./INSTALL.sh local
    cd .. && rm -rf epitech-emacs
    # CRITERION
    curl -sSL "https://github.com/Snaipe/Criterion/releases/download/v2.4.2/criterion-2.4.2-linux-x86_64.tar.xz" -o criterion.tar.xz
    tar -xf criterion.tar.xz
    sudo cp -r criterion-2.4.2/* /usr/local
    sudo echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local.conf
    sudo ldconfig
    rm -rf criterion-2.4.2/ criterion.tar.xz
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
