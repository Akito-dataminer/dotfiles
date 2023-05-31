#!/bin/bash

DOTFILES_ROOT=$(dirname $0)
cd $DOTFILES_ROOT

for f in .??*; do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".gitmodules" ] && continue
  [ "$f" = ".gitignore" ] && continue

  ln -snfv ~/dotfiles/"$f" ~/
done
