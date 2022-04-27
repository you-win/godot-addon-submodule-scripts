#!/bin/bash

set -e

if [[ $# -ne 2 ]]; then
    echo "Expected 2 args"
    echo ""
    echo "arg1 = addons/<name>"
    echo "arg2 = git repo url"
    exit 1
fi

echo "Adding submodule $2 into $1"

git submodule add -b addon-submodule "$2" "addons/$1" &> /dev/null

echo "Done"
