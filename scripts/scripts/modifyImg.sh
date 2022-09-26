#!/bin/bash
# the following tools are needed:
#   identify, convert, exiftool, mogrify
# logic:
#   rename rename image
#   rotate image and update metadata
#   resize image

GEOMETRY="1920x1080"
HEIGHT="1080"
WIDTH="1920"
PICTS=`find . -iname "*.jpg"`

for PICT in $PICTS; do
    NEWNAME=`echo $PICT | sed -e "s/JPG/jpg/" -e "s/IMG/img/"`
    echo -n "$NEWNAME ... "
    mv $PICT $NEWNAME 2>/dev/null

    case `identify -format '%[EXIF:Orientation]' $NEWNAME` in
        1) transform="";;
        2) transform="-flop";;
        3) transform="-rotate 180";;
        4) transform="-flip";;
        5) transform="-transpose";;
        6) transform="-rotate 90";;
        7) transform="-transverse";;
        8) transform="-rotate 270";;
        *) transform="";;
    esac

    if test -n "$transform"; then
        echo -n "$transform ... "
        convert $transform $NEWNAME $NEWNAME
        exiftool -Orientation=1 -n $NEWNAME
    fi

    #convert $NEWNAME -resize "$WIDTHx$HEIGHT"\> $NEWNAME
    #exiftool -exifimagewidth=$WIDTH -exifimageheight=$HEIGHT $NEWNAME
    chmod +r $NEWNAME
    echo "done "
done


