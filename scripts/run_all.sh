#!/bin/bash

set -e
set -o nounset

folder=${1:-"runs"}

for os in windows linux; do
  ./run.sh ap-benchmark-${os}.azurewebsites.net ${folder}
done
