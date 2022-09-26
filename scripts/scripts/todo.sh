#!/bin/bash
(
	mkdir -p ~/.config/todo
	cd ~/.config/todo
	touch todolist # touch creates a file if it doesn 't exist yet

	while getopts 'i : d : h ' opt; do
		case " $opt " in
		h | \?)
			echo ' Valid flags : -i -d -h '
			;;
		i)
			echo " $OPTARG " >>todolist
			;;
		d)
			# sed '3 d ' deletes the 3 rd line from a file .
			sed -e " $ { OPTARG } d " todolist >/tmp/todolist
			cp /tmp/todolist todolist
			;;
		esac
	done
	# the -n option adds line numbers
	cat -n todolist
)
