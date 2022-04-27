#!/bin/bash

set -e

if [[ $# -ne 3 ]]; then
    echo "Expected 3 args"
    echo ""
    echo "arg1 = branch | tag"
    echo "arg2 = branch/tag value"
    echo "arg3 = project name"
    exit 1
fi

addons_folder="addons"
submodule_branch="addon-submodule"

echo "Creating release for $1 - $2 - $3"

if ! git "$1" --list 2> /dev/null | grep -q -w "$2"; then
    echo "Options $1 - $2 do not exist for the current repo, aborting"
    exit 1
fi

if ! find "./$addons_folder" -type d -name "$3" &> /dev/null; then
    echo "Folder $3 does not exist, aborting"
    exit 1
fi

if git branch --list 2> /dev/null | grep -q -w "$submodule_branch"; then
    echo "Submodule branch already exists"
    echo "Deleting $submodule_branch"
    git branch -D "$submodule_branch" > /dev/null
fi

# Store so we can go back
current_branch=$(git rev-parse --abbrev-ref HEAD)

git checkout "$2" &> /dev/null

if ! find "$addons_folder" -type d 2> /dev/null | head -n 1 2> /dev/null | grep -q -w "$addons_folder"; then
    echo "$addons_folder not found in the current directory"
    exit 1
fi

git checkout -b "$submodule_branch" &> /dev/null

echo "Removing everything except for $addons_folder"

find . -type f,d -name "*" ! -path "./addons*" ! -path "./.git*" ! -path "." -exec rm -rf {} + &> /dev/null
# Cleanup .gitignore and .gitattributes, if they exist. They are initially missed since we don't want to delete the .git directory
find . -type f -name ".git*" -exec rm {} + &> /dev/null

echo "Unpacking $addons_folder/$3"

# find "$addons_folder/$3" -mindepth 1 -type d -print -exec mv {} . \; > /dev/null

find "$addons_folder/$3" -mindepth 1 -maxdepth 1 -type d,f -print -exec mv {} . \; > /dev/null

echo "Removing $addons_folder"

rm -rf "$addons_folder"

echo "Committing all changes"

git add --all &> /dev/null
git commit -m "packaging as submodule" &> /dev/null

echo "Force pushing to origin"

git push -u -f origin "$submodule_branch" &> /dev/null

echo "Switching back to $current_branch"

git checkout "$current_branch" &> /dev/null

echo "Reverting deletions in $current_branch"

git checkout master &> /dev/null
git reset --hard &> /dev/null
rm -rf "$3" &> /dev/null

echo "Done"
