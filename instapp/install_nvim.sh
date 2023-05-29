#!/bin/bash

####################
# install Neovim
####################
read -ep "directory you want to install nvim.appimage: " NVIM_DIST

NVIM_DIST="${NVIM_DIST/#\~/$HOME}"

if [ ! -d $NVIM_DIST ]; then
  mkdir -p $NVIM_DIST
fi

# reference: https://github.com/neovim/neovim/wiki/Installing-Neovim#appimage-universal-linux-package
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage $NVIM_DIST
ln -snvf $NVIM_DIST nvim.appimage /usr/local/bin/nvim

sudo apt install libfuse-dev

####################
# install deno
####################
sudo apt install unzip # unzip is needed by script to install deno.

curl -fsSL https://deno.land/x/install/install.sh | sh

echo -e "export DENO_INSTALL=\"$HOME/.deno/\"\nexport PATH=\"\$DENO_INSTALL/bin:\$PATH\"" >> .profile

####################
# install npm
# Reference: https://qiita.com/nouernet/items/d6ad4d5f4f08857644dep
####################
sudo apt -y install nodejs npm

sudo n stable
sudo apt purge -y nodejs npm
sudo apt autoremove -y

echo installed npm version: $(npm -v)
echo installed node.js version: $(node -v)
