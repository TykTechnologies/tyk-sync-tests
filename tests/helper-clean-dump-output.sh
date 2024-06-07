#!/usr/bin/env bash

set -e

while IFS= read -r line; do
  rm -f ../test/"$line"
done <<< "$(ls ../test | grep -e '.json$')"

rm -f ../test/.tyk.json