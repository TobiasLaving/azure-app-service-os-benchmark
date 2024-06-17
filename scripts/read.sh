#!/bin/bash

set -e
set -o nounset

folder=${1:-"runs"}

for size in 1 10 100; do
  for os in linux windows; do
    data=$(cat ${folder}/ap-benchmark-${os}.azurewebsites.net_${size})
    echo "$os - $size kB"
    grep "Time taken for tests" <<< $data
    grep "Requests per second" <<< $data
    grep "Time per request" <<< $data
    echo ""
  done
  echo ""
done

