#!/bin/bash

set -euo pipefail

####################
# install Neovim
####################
NVIM_NAME="nvim-linux-x86_64"
NVIM_ASSET=${NVIM_NAME}".tar.gz"
NVIM_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | \
  grep -oP "browser_download_url.*\Khttps://.*${NVIM_ASSET}" | head -n1)

OPT_DIR="/opt/nvim-linux-x86_64"
SYMLINK="/usr/local/bin/nvim"

tmp="$(mktemp -d "/tmp/installing_neovim.tmp.XXXXXX")"
cleanup() {
  if [[ -d "${tmp}" ]]; then
    rm -rf "$tmp"
  fi
}
trap cleanup EXIT
trap 'rc=$?; trap - EXIT; atexit; exit $?' INT PIPE TERM

package="${tmp}/${NVIM_ASSET}"

curl -fL -o "${package}" "$NVIM_URL"

sudo rm -rf "$OPT_DIR"
sudo tar -C /opt -xzf "$package"

sudo mkdir -p "$(dirname "$SYMLINK")"

if [ ! -f /usr/local/bin/nvim ]; then
  sudo ln -sn "${OPT_DIR}/bin/nvim" "$SYMLINK"
fi

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
