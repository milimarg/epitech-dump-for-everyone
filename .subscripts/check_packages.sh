#!/bin/bash

function check_packages()
{
  if [[ "$?" -ne 0 ]]; then
    echo "Failed to install packages"
    exit 1
  fi
}
