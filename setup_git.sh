#!/bin/bash

function ask_yes_or_no() {
  read -p "$1" YES_OR_NO

  if [[ $YES_OR_NO == 'y' || $YES_OR_NO == 'Y' || $YES_OR_NO == "yes" ]]; then
    return 1
  fi

  return 0
}

is_exist() {
  command -v "$@" > /dev/null
  echo $?
}

if hash git >/dev/null 2>&1; then
  echo "git is able to be executed."
else
  echo "git is not able to be executed."
  echo "Please install git"
  exit 1
fi

##########
# user config
##########
read -p 'Please type your user name: ' USER_NAME
read -p 'Please type your email address: ' EMAIL_ADDRESS

git config --global user.name "$USER_NAME"
git config --global user.email "$EMAIL_ADDRESS"

##########
# change default branch
##########
ask_yes_or_no "Do you want to set the default branch to main? [y]es/[n]o: "

if [[ $? == 1 ]]; then
  git config --global init.defaultBranch main
  echo "Default branch is set to main"
fi

##########
# change the default editor
##########
read -p "which editor do you want to use in git? - " SPECIFIED_EDITOR

while [ 1 ]; do
  if [ $(is_exist ${SPECIFIED_EDITOR}) -eq 0 ]; then break; fi

  echo the editor is not installed.
  read -p "which editor do you want to use in git? - " SPECIFIED_EDITOR
done

git config --global core.editor ${SPECIFIED_EDITOR}
