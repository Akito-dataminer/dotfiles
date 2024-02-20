#!/bin/bash

####################
# install Neovim
####################
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz

tar -zxf nvim-linux64.tar.gz
mv nvim-linux64/bin/nvim /usr/bin/nvim
mv nvim-linux64/lib/nvim /usr/lib/nvim
mv nvim-linux64/share/nvim/ /usr/share/nvim
rm -rf nvim-linux64
rm nvim-linux64.tar.gz

sudo apt-get install -y libfuse-dev

####################
# install deno
####################
sudo apt-get install -y unzip # unzip is needed by script to install deno.

curl -fsSL https://deno.land/x/install/install.sh | sh

echo -e "export DENO_INSTALL=\"$HOME/.deno/\"\nexport PATH=\"\$DENO_INSTALL/bin:\$PATH\"" >> ../.profile
ln -snfv ~/dotfiles/.profile ~/

####################
# install npm
# Reference: https://www.softel.co.jp/blogs/tech/archives/6487
####################
sudo apt-get -y install nodejs npm

sudo npm install -g n
sudo n stable
sudo apt-get purge -y nodejs npm
sudo apt-get autoremove -y

echo installed npm version: $(npm -v)
echo installed node.js version: $(node -v)
