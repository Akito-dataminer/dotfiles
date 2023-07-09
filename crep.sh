#!/bin/bash
# このスクリプトを実行したディレクトリに、第一引数で指定した名前で、
# SKELETON_SRCに置いたスケルトンプロジェクトをコピーする。

CURRENT_DIR="`pwd`" # the directory from which this script was called
DIST_DIR=${CURRENT_DIR}/$1

# 既にあるプロジェクトを破壊しないための防護策
if [ -e $DIST_DIR ]; then
  echo "the name has been used"
  exit
fi

SKELETON_PAIRENT_DIR=$(cd $(dirname $0); pwd) # the directory put this script
SKELETON_DIR_NAME=.cpp_skeleton
SKELETON_SRC=${SKELETON_PAIRENT_DIR}/${SKELETON_DIR_NAME}

SKELETON_LIST="`find ${SKELETON_SRC}`" 

EXECLUDE_LIST=('.git' 'LICENSE.md')
for src_path in $SKELETON_LIST; do
  dist_path=${DIST_DIR}${src_path##*${SKELETON_DIR_NAME}}

  is_execlude=0
  for execlude in ${EXECLUDE_LIST[@]}; do
    if [ `basename ${dist_path}` == ${execlude} ]; then
      is_execlude=1
      # echo "delete : ${dist_path}" # for debug
      break
    fi
  done
  if [ ${is_execlude} -eq 1 ]; then continue; fi

  # ここからがコピーしたり、ディレクトリを作ったりする部分
  if [ -d ${src_path} ]; then
    # echo "directory: ${dist_path}" # for debug
    mkdir ${dist_path}
  else
    # echo "file: ${dist_path}" # for debug
    cp ${src_path} ${dist_path}
  fi
done
