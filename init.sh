#!/usr/bin/env bash

set -e

echo "... Creating 5 Classic, 5 OAS API Definitions and 5 Policies"
MAX=5 TYK_AUTH=$TYK_AUTH TYK_URL=$TYK_URL ./create-apis.sh
echo "... Created"

venom run -vv ./tests/dump.yaml --var="TYK_AUTH=$TYK_AUTH"  --var="TYK_URL=$TYK_URL"
venom run -vv ./tests/sync.yaml --var="TYK_AUTH=$TYK_AUTH"  --var="TYK_URL=$TYK_URL"
