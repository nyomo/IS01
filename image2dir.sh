#!/bin/sh
UNUBINIZE=unubinize.pl
SPLIT_BOOTIMAGE=split_bootimg.pl
IMGDIR=./img

BASEIMAGE=$*
if [ -z $BASEIMAGE ]
	then echo "usage: img2dir.sh targetbootimage(in $IMGDIR)";exit
fi
if [ -f ${IMGDIR}/${BASEIMAGE} ]
then
	cd $IMGDIR
	$UNUBINIZE $BASEIMAGE
	$SPLIT_BOOTIMAGE $BASEIMAGE.out
	cd ..
	mkdir ${BASEIMAGE}
	cd ${BASEIMAGE}
	cat ../${IMGDIR}/${BASEIMAGE}.out-ramdisk.cpio|cpio -i
else
	echo "cannot found $IMGDIR/$BASEIMAGE"
fi
