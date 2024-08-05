#!/bin/bash

function install_raylib() {
  git clone https://github.com/raysan5/raylib.git raylib
  cd raylib/src/ || (echo "Couldn't clone raylib repository..."; exit 1)
  make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED
  sudo make install RAYLIB_LIBTYPE=SHARED
  cd ../../ && rm -rf raylib
}
