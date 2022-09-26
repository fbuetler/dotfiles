#!/bin/bash

while getopts "hf:" option
do
	case "$option" in
	h)
		echo "available options: -h, -f ARGUMENT"
		exit 0
		;;
	f)
		echo "argument: $OPTARG"
		;;
	esac
done

shift $((OPTIND-1))
