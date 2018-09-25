#!/bin/bash

cd $1
for subdir in *
do
if [ ! -e $subdir/data/content.* ]
then
echo "the file in $subdir is missing\n"
fi
done
