#!/usr/bin/env bash

set -e

if [[ -z "$TYK_AUTH" ]]; then
    echo "failed to parse TYK_AUTH, please specify TYK_AUTH"
    exit 1
fi

if [[ -z "$TYK_URL" ]]; then
    echo "failed to parse TYK_URL, please specify TYK_URL"
    exit 1
fi


# Function to handle errors
handle_error() {
    echo "An error occurred at line $1." >&2
    exit 1
}

trap 'handle_error $LINENO' ERR

curl -sL https://raw.githubusercontent.com/buraksekili/populate-apis/master/create.sh | TYK_AUTH="$TYK_AUTH" TYK_URL="$TYK_URL" bash > /dev/null 2>&1
