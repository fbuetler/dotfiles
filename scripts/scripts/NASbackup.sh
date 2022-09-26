#!/bin/bash

if grep -qs '/mnt/NAS/florian ' /proc/mounts; then
    echo "It's mounted."
    rsync -avP \
        --exclude "Downloads/" \
        --exclude "Dropbox/" \
        --exclude "git/" \
        --exclude "go/" \
        --exclude "tmp/" \
        --exclude "VirtualBox VMs/" \
        --exclude ".*" \
        $HOME/ $HOME/NASbackup/
else
    echo "It's not mounted."
fi
