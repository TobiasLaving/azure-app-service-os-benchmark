#!/bin/bash

set -e
set -o nounset

host=$1
folder=${2:-"runs"}

mkdir -p $folder

# TL: Warm up
curl --silent -o /dev/null "${host}/test"

for size in 1 10 100; do
  sleep 10 # TL: Let it rest
  formatted_host=${host#http://}
  formatted_host=${formatted_host#https://}
  
  ab -n 5000 -c 150 "${host}/test?size=$size" > ${folder}/${formatted_host}_${size}
done

