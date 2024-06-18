#!/bin/bash

set -e
set -o nounset

folder=${1:-"runs"}


function read_data() {
  local file=$1
  data=$(cat $file)
  d1=$(grep "Time taken for tests:" <<< "$data" | awk '{print $5}')
  d2=$(grep "Requests per second:" <<< "$data" | awk '{print $4}')
  d3=$(grep "Time per request:" <<< "$data" | grep "(mean)" | awk '{print $4}')
  echo "$d1 $d2 $d3"
}

cat "${folder}/env_info.txt"
echo ""

echo "| Response size | Measurement | Linux | Windows"
echo "|--|--|--|--|"

for size in 1 10 100; do
  
  read -r l1 l2 l3 <<< $(read_data ${folder}/ap-benchmark-linux.azurewebsites.net_${size})
  read -r w1 w2 w3 <<< $(read_data ${folder}/ap-benchmark-windows.azurewebsites.net_${size})

  echo "| **$size kb** | |"
  echo "| | Total time [seconds] | $l1 | $w1"
  echo "| | Requests per seconds [#/sec]| $l2 | $w2"
  echo "| | Mean time per request [ms] | $l3 | $w3"

done

