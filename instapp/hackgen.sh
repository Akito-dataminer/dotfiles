#!/bin/bash
# HackGenをインストールするためのスクリプト
# HackGen: https://github.com/yuru7/HackGen
# release: https://github.com/yuru7/HackGen/releases

PROJECT_NAME="HackGen_NF"
PROJECT_ASSET=${PROJECT_NAME}".zip.gz"
PROJECT_URL=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | \
  grep -oP "browser_download_url.*\Khttps://.*${PROJECT_ASSET}" | head -n1)
