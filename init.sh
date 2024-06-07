#!/usr/bin/env bash

set -e

echo "... Clean Tyk resources"
TYK_AUTH=$TYK_AUTH TYK_URL=$TYK_URL ./clean-apis.sh
echo "... Created"

echo "... Creating 5 Classic, 5 OAS API Definitions and 5 Policies"
MAX=5 TYK_AUTH=$TYK_AUTH TYK_URL=$TYK_URL ./create-apis.sh
echo "... Created"

echo "... Testing tyk-sync dump"
venom run --output-dir=logs --stop-on-failure -vv ./tests/dump.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"

echo "... Testing tyk-sync sync"
venom run --output-dir=logs --stop-on-failure -vv ./tests/sync.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"

echo "Running dump-2-apis.yaml"
venom run --output-dir=logs --stop-on-failure -vv ./tests/dump-2-apis.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"
