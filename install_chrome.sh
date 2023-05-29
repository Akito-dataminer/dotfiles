#!/bin/bash
# This script install the google-chrome with wget and dpkg commands.

is_exist() {
  command -v "$@" > /dev/null
  echo $?
}

wget_exist=`is_exist wget`

if [ ${wget_exist} -ne 0 ] ; then
  echo wget is not exist.
  exit
fi

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
