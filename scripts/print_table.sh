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
  d4=$(grep "Time per request:" <<< "$data" | grep "(mean, across all concurrent requests)" | awk '{print $4}')
  echo "$d1 $d2 $d3 $d4"
}

for size in 1 10 100; do
  
  read -r l1 l2 l3 l4 <<< $(read_data ${folder}/ap-benchmark-linux.azurewebsites.net_${size})
  read -r w1 w2 w3 w4 <<< $(read_data ${folder}/ap-benchmark-windows.azurewebsites.net_${size})

  echo "| | **$size kb** | |"
  echo "| | Total time [seconds] | $l1 | $w1"
  echo "| | Requests per seconds | $l2 | $w2"
  echo "| | Time per request (mean) [ms] | $l3 | $w3"
  echo "| | Time per request (mean, across all concurrent requests) [ms] | $l4 | $w4"


done

