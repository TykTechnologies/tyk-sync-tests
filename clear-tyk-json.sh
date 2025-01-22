#!/bin/bash

if ! command -v jq &> /dev/null; then
  echo "jq is not installed. Please install jq before running this script."
  exit 1
fi

APP_DIR=$(dirname "$0")

INPUT_FILE="$APP_DIR/test/.tyk.json"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Input file $INPUT_FILE not found."
  exit 1
fi

jq '.files = [] | .policies = []' "$INPUT_FILE" > "$INPUT_FILE.tmp" && mv "$INPUT_FILE.tmp" "$INPUT_FILE"

echo "Cleared 'files' and 'policies' arrays in $INPUT_FILE."
