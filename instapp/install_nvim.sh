#!/bin/bash

####################
# install Neovim
####################
NVIM_NAME="nvim-linux-x86_64"
NVIM_ASSET=${NVIM_NAME}".tar.gz"
NVIM_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | \
  grep -oP "browser_download_url.*\Khttps://.*${NVIM_ASSET}" | head -n1)

curl -LO $NVIM_URL

tar -zxf $NVIM_ASSET
cp -r ${NVIM_NAME}/bin/nvim /usr/bin/nvim
cp -r ${NVIM_NAME}/lib/nvim /usr/local/lib/nvim
cp -r ${NVIM_NAME}/share/nvim /usr/local/share/nvim
rm -rf ${NVIM_NAME}
rm ${NVIM_ASSET}

ln -s /usr/bin/nvim /usr/local/bin/nvim

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
