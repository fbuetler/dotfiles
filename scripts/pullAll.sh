#!/bin/bash

for dir in */ ; do
    if [[ ! -d "$dir" && ! -d .git ]]
    then
        continue
    fi
    cd ./$dir
    echo "=== $dir ==="
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
    cd ..
    echo ""
done
