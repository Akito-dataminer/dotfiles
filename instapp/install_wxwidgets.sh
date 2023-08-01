#!/bin/bash

####################
# install jq to install xremap, if it is not exist
####################
JQ_EXIST=`sh ./helper/is_exist.sh jq`

if [ ! ${JQ_EXIST} == '0' ]; then
  echo jq is not installed.
  echo install jq
  sudo apt install -y jq
  echo the installation has been finished.
fi

####################
# download and extract wxWidgets
####################
OWNER="wxWidgets"
REPO="wxWidgets"
GITHUB_REPOSITORY=https://api.github.com/repos/${OWNER}/${REPO}/releases/latest
TMP_FILE=/tmp/gh_api_response-${REPO}

curl -sL -H "Accept: application/vnd.github+json" ${GITHUB_REPOSITORY} --output "${TMP_FILE}"

LATEST_VERSION=$(cat ${TMP_FILE} | jq -r .tag_name)
echo install version: "${LATEST_VERSION}"

ASSET_NUM=$(cat ${TMP_FILE} | jq '[.assets[]] | length')
INDEX_ARRAY=$(seq ${ASSET_NUM})
ASSET_URIS=$(cat ${TMP_FILE} | jq -r '.assets[] | .browser_download_url | select( . )')
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

DOWNLOADED_FILE=$(basename ${INSTALL_URI})
DOWNLOADED_FILE_EXTENSION=${INSTALL_URI##*.}
# wxWidgetsは圧縮ファイルがwxWidgets-<バージョン>.tar.bz2という
# 名前になっているので、-以降を無くしたい。
# 注釈： tarでダウンロードしてきたファイルを解凍すると、
#   wxWidgets-<バージョン>という名前になる。
#   しかし、そのような名前を抽出する(-3.2.2.1.tar.bz2から、
#   tar.bz2だけを消す)のは面倒なので、wxWidgetsという名前の
#   ディレクトリに出力するように指定している。
EXTRACT_DIR=${DOWNLOADED_FILE%%-*}

mkdir ${EXTRACT_DIR}

echo Now extracting
if [ ${DOWNLOADED_FILE_EXTENSION} == "bz2" ]; then
  tar -jxvf ${DOWNLOADED_FILE} --directory=${EXTRACT_DIR} --strip-components=1 > /dev/null
elif [ ${DOWNLOADED_FILE_EXTENSION} == "zip" ]; then
  unzip ${DOWNLOADED_FILE} -d ${EXTRACT_DIR}
fi
echo extraction is finished.
rm ${DOWNLOADED_FILE}

####################
# build & install wxWidgets
####################
echo build wxWidgets
PROCESSOR_NUM=$(fgrep 'processor' /proc/cpuinfo | wc -l)
cd ${EXTRACT_DIR}
mkdir build_gtk
cd build_gtk/
../configure --enable-debug --enable-unicode --disable-shared --prefix=/usr/local
make -j${PROCESSOR_NUM}
sudo make install
sudo ldconfig
rm -rf ${EXTRACT_DIR}

####################
# check if wxWidgets was successfully installed.
####################
echo execute 'wx-config --version'
wx-config --version
