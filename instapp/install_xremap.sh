#!/bin/bash

is_exist() {
  command -v "$@" > /dev/null
  echo $?
}

####################
# install jq to install xremap, if it is not exist
####################
JQ_EXIST=`is_exist jq`

if [ ${JQ_EXIST} -ne 0 ] ; then
  echo install jq
  sudo apt install -y jq
  echo the install has been finished.
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

# errorが起きている。
while [ 1 ]; do
  if [[ "$ORDERED_INDEX" =~ ^[0-9]+$ && $((ORDERED_INDEX)) -lt $((ASSET_NUM)) ]]; then break; fi

  echo input is not valid
  read -p "which asset do you want to install? - " ORDERED_INDEX
done

wget ${ASSET_URI_ARRAY[${ORDERED_INDEX}]}
