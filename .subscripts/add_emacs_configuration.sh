#!/bin/bash

function add_emacs_configuration() {
  git clone https://github.com/Epitech/epitech-emacs.git
  cd epitech-emacs || (echo "Couldn't clone epitech emacs configuration..." ; exit 1)
  ./INSTALL.sh local
  cd .. && rm -rf epitech-emacs
}
