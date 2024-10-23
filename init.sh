#!/usr/bin/env bash
cd "$(dirname "$0")"

set -e

if which tyk-sync &> /dev/null; then
    echo "tyk-sync exists on the machine, version: $(tyk-sync version)"
else
    echo "tyk-sync does not exist"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq does not exist"
    exit 1
fi

curl https://github.com/ovh/venom/releases/download/v1.2.0/venom.linux-amd64 -L -o /usr/local/bin/venom && chmod +x /usr/local/bin/venom
echo "using venom $(venom -h)"

TYK_AUTH=$(echo "$TYK_AUTH" | xargs)

initTykResources() {
  echo "... Clean test folder"
  rm -f ./test/*.json
  rm -f ./test/.tyk.json
  sleep 1;
  echo "... Cleaned"

  echo "... Clean resources on Tyk"
  TYK_AUTH=$TYK_AUTH TYK_URL=$TYK_URL ./clean-apis.sh
  echo "... Cleaned"

  echo "... Creating 5 Classic, 5 OAS API Definitions and 5 Policies"
  TYK_AUTH=$TYK_AUTH TYK_URL=$TYK_URL ./create-apis.sh
  echo "... Created"
}

initTykResources

echo "... Testing tyk-sync dump"
venom run --output-dir=./logs --stop-on-failure -vv ./tests/dump.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"

initTykResources

echo "... Testing tyk-sync sync"
venom run --output-dir=./logs --stop-on-failure -vv ./tests/sync.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"

initTykResources

echo "... Testing tyk-sync dump command with specific APIs"
venom run --output-dir=./logs --stop-on-failure -vv ./tests/dump-specific-apis.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"

initTykResources

echo "... Testing tyk-sync publish command to update resources"
venom run --output-dir=./logs --stop-on-failure -vv ./tests/publish.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"

initTykResources

echo "... Testing tyk-sync update command to update resources"
venom run --output-dir=./logs --stop-on-failure -vv ./tests/update.yaml --var="TYK_AUTH=$TYK_AUTH" --var="TYK_URL=$TYK_URL"
