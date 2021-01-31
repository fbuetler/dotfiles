#!/bin/sh

GEOMETRY="-geometry 1920x1920"
PICTS=`find . -iname "*.jpg"`

for PICT in $PICTS; do
	NEWNAME=`echo $PICT | sed -e "s/JPG/jpg/" -e "s/IMG/img/"`
	echo -n $NEWNAME ...
	mv $PICT $NEWNAME
	exifautotran.sh $NEWNAME
	mogrify $GEOMETRY $NEWNAME
	chmod +r $NEWNAME
	echo done
done
