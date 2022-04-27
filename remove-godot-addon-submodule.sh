#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Expected 1 args"
    echo ""
    echo "arg1 = submodule/path"
    exit 1
fi

dir=${1%/}

echo "Removing submodule $dir"

git rm "$dir" -f > /dev/null

echo "Removing .git configs"

rm -rf ".git/modules/$dir" > /dev/null
git config --remove-section submodule."$dir" > /dev/null

echo "Done"
