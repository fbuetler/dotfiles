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
        /home/florian/ /home/florian/NASbackup/
else
    echo "It's not mounted."
fi
