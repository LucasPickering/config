#!/bin/sh

# Git branch grep
branches=$(git branch -a | rg "$@" | rg "^\s*remotes/\w+/(.*)$" -r '$1')
if [ "$branches" == "" ]; then
    echo "No branches"
elif [ $(echo "$branches" | wc -l) == 1 ]; then
    git checkout "$branches"
else
    echo "$branches"
fi
