#!/bin/bash

set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
    echo "[Error] This script requires root privileges. Please run it with sudo." >&2
    exit 1
fi

####################
# install Neovim
####################
NVIM_ASSET="nvim-linux-x86_64.tar.gz"
NVIM_REPO="neovim/neovim"
NVIM_BASE_DL="https://github.com/${NVIM_REPO}/releases/latest/download"

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

echo "[1/3] Downloading: ${NVIM_ASSET}"
curl -fL -o "${package}" "${NVIM_BASE_DL}/${NVIM_ASSET}"

echo "[2/3] Installing to: ${OPT_DIR}"
sudo rm -rf "$OPT_DIR"
sudo tar -C /opt -xzf "$package"

echo "[3/3] Updating symlink: ${SYMLINK} -> ${OPT_DIR}/bin/nvim"
sudo mkdir -p "$(dirname "$SYMLINK")"
sudo ln -sfn "${OPT_DIR}/bin/nvim" "$SYMLINK"

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
