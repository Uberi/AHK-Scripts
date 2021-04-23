#!/bin/sh

# Location to save ebook
OPATH=`pwd`

# Custom dir to build in
BPATH='/tmp/ahkbook_build'
mkdir $BPATH
cd $BPATH

# clone from parent directory
git clone $OPATH/.. ahkbook
cd ahkbook

jekyll --url '..' # create the site
cd _site

sed -i "s/href='\.\.\/css\/\([^\n]\+\)\.css'/href='css\/\1\.css'/g" index.html # correct the css urls in the index
sed -i "s/href='\.\.\/icon\.png'/href='icon\.png'/g" index.html # correct the favicon url in the index

# call scripts
sh $OPATH/zip.sh "$OPATH"

cd $OPATH # cleanup
rm -R -f $BPATH
