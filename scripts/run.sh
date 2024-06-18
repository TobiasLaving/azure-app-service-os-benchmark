#!/bin/bash

set -e
set -o nounset

num_requests=${BENCHMARK_NUM_REQUESTS:-5000}
num_concurrency=${BENCHMARK_NUM_CONCURRENCY:-150}
host=$1
folder=${2:-"runs"}

mkdir -p "$folder"

# TL: Warm up
curl --silent -o /dev/null "${host}/test"

for size in 1 10 100; do
  sleep 10 # TL: Let it rest
  formatted_host=${host#http://}
  formatted_host=${formatted_host#https://}
  
  ab -n "$num_requests"  -c "$num_concurrency" "${host}/test?size=$size" > "${folder}/${formatted_host}_${size}"
done

echo "BENCHMARK_NUM_REQUESTS=$num_requests" > "${folder}/run_info.env"
echo "BENCHMARK_NUM_CONCURRENCY=$num_concurrency" >> "${folder}/run_info.env"
