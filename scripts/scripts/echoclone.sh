#!/bin/bash

for i in "$@"
do
	notify-send "$i"
done
