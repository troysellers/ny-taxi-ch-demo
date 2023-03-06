#!/bin/bash

curl -O https://s3.amazonaws.com/menusdata.nypl.org/gzips/2021_08_01_07_01_17_data.tgz
tar xvf 2021_08_01_07_01_17_data.tgz
echo "finished"
