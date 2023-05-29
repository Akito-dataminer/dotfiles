#!/bin/bash

is_exist() {
  command -v "$@" > /dev/null
  echo $?
}

function ask_yes_or_no() {
  read -p "$1" YES_OR_NO

  if [[ $YES_OR_NO == 'y' || $YES_OR_NO == 'Y' || $YES_OR_NO == "yes" ]]; then
    return 1
  fi

  return 0
}

####################
# install jq to install xremap, if it is not exist
####################
JQ_EXIST=`is_exist jq`

if [ ${JQ_EXIST} -ne 0 ]; then
  echo jq is not installed.
  echo install jq
  sudo apt install -y jq
  echo the installation has been finished.
fi

####################
# install xremap
####################
XREMAP_URI="k0kubun/xremap"
TMP_FILE=/tmp/xremap_install
curl -sL -H "Accept: application/vnd.github+json" https://api.github.com/repos/${XREMAP_URI}/releases/latest --output "${TMP_FILE}"

CURRENT_VERSION=$(cat ${TMP_FILE} | jq -r .tag_name)
echo install version: "${CURRENT_VERSION}"

ASSET_NUM=$(cat ${TMP_FILE} | jq '[.assets[]]|length')
INDEX_ARRAY=$(seq ${ASSET_NUM})
ASSET_URIS=$(cat ${TMP_FILE} | jq -r '.assets[] | .browser_download_url |select( . )')
ASSET_URI_ARRAY=(`echo $ASSET_URIS`)

for (( i = 0; i < ${#ASSET_URI_ARRAY[@]}; i++ )); do
  echo "$i: ${ASSET_URI_ARRAY[$i]}"
done

read -p "which asset do you want to install? - " ORDERED_INDEX

while [ 1 ]; do
  if [[ "$ORDERED_INDEX" =~ ^[0-9]+$ && $((ORDERED_INDEX)) -lt $((ASSET_NUM)) ]]; then break; fi

  echo input is not valid
  read -p "which asset do you want to install? - " ORDERED_INDEX
done

INSTALL_URI=${ASSET_URI_ARRAY[${ORDERED_INDEX}]}

wget ${INSTALL_URI}
unzip ${INSTALL_URI##*/}

sudo chmod 750 xremap

####################
# config xremap( copy config files for xremap to some directries )
####################
sudo mkdir -p /usr/local/etc/xremap
sudo mv .xremap/config.yml /usr/local/etc/xremap/config.yml

sudo mv xremap /usr/local/bin/
sudo systemctl enable xremap

ask_yes_or_no "Do you want to start xremap now? [y]es/[n]o: "

if [[ $? == 1 ]]; then
  sudo systemctl start xremap
fi
