# epitech-dump-for-everyone

If you wish to install the dump on a dnf-based distro (i.e. Fedora), head over to https://github.com/Epitech/dump.

You've always wanted to install the Epitech dump on a non-dnf-based distro, but you're too lazy to install the packages? That script is the solution!

- [How to install?](#how-to-install)
- [Tested on](#tested-on)
- [Install Raylib Dependencies](#install-raylib-dependencies) (even on Fedora) (TEK2/TEK3)
- [Install Raylib](#install-raylib) (TEK2/TEK3)

## How to install?

```shell
git clone https://github.com/milimarg/epitech-dump-for-everyone
cd epitech-dump-for-everyone
./install.sh
```

## Tested on

### `Debian-based (apt)`
##### Debian, Crunchbang++, Kali Linux

### `Ubuntu-based (apt)`
##### Ubuntu, Pop!_OS

### `Arch Linux-based (pacman)`
##### Arch Linux, Manjaro, Garuda Linux
:warning: Haskell Compiler won't be installed

### `Open SUSE (zypper)`
##### OpenSUSE Tumbleweed, OpenSUSE Leap
:warning: CSFML won't be installed

## Install Raylib (Dependencies)

### apt

:information_source: soon

### pacman

:information_source: soon

### zypper

:information_source: soon

### dnf

```shell
sudo dnf install wayland-devel libxkbcommon-devel libXcursor-devel libXrandr-devel libXinerama-devel libXi-devel
```

## Install Raylib

```shell
git clone https://github.com/raysan5/raylib.git raylib
cd raylib/src/
make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED
sudo make install RAYLIB_LIBTYPE=SHARED
```
