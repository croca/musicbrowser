#!/bin/bash

function die {
  echo
  echo ERROR: $*
  exit 1
}

if [ ! -f "src/musicbrowser.php" ]; then
  die cannot find src/musicbrowser.php
fi

VERSION=`grep '^define..VERSION' src/musicbrowser.php | cut -d\' -f4`
ZIPFILE="musicbrowser-$VERSION.zip"
if [ -f $ZIPFILE ]; then
  die $ZIPFILE already exists
fi

FOLDER="musicbrowser"
if [ -d $FOLDER ]; then
  die the $FOLDER folder already exists
fi

phpunit test
if [ $? -ne 0 ]; then
  die Did not pass unit tests
fi

mkdir $FOLDER
cp src/* $FOLDER/
rm $FOLDER/*~
zip -r $ZIPFILE $FOLDER && rm -r $FOLDER && echo && echo Created $ZIPFILE