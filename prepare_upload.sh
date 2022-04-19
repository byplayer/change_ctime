#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
  echo 'usage: prepare_upload.sh TARGET_DIR'
  exit 1
fi

set -eu

LOG=$(pwd)/log/$(date '+%Y%m%d%H%M%S').log

SOURCE_DIR=$1

echo prepare data from: ${SOURCE_DIR} >> ${LOG}

bundle exec ruby change_20_files.rb ${SOURCE_DIR} >> ${LOG} 2>&1

echo prepare data has been completed >> ${LOG}

find ${SOURCE_DIR} -name .DS_Store | xargs --no-run-if-empty rm >> ${LOG} 2>&1

mkdir -p ~/work/tmp
pushd ~/work/tmp

rm -f '*.*'


if [ -f .DS_Store ]; then
  rm .DS_Store
fi

echo copy file to tmp >> ${LOG} 2>&1
find ${SOURCE_DIR} -type f -print0 | xargs -0 cp -i -t ./ >> ${LOG} 2>&1
echo copy file to tmp completed >> ${LOG} 2>&1

cd $SCRIPT_DIR

echo change file chtime >> ${LOG} 2>&1
bundle exec ruby chtime_by_fname.rb ~/work/tmp >> ${LOG} 2>&1

echo !!!!!done!!!!! >> ${LOG} 2>&1
