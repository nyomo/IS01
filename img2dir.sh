#!/bin/sh
UNUBINIZE=unubinize.pl
SPLIT_BOOTIMAGE=split_bootimg.pl
IMGDIR=./img

BASEIMAGE=$*
[ ! -d $IMGDIR ] && echo "error:do mkdir ./img" && exit
[ -z $BASEIMAGE ]&& echo "usage: img2dir.sh targetbootimage(in $IMGDIR)"&&exit
if [ -f ${IMGDIR}/${BASEIMAGE} ]
then
	cd $IMGDIR
	$UNUBINIZE $BASEIMAGE
	$SPLIT_BOOTIMAGE $BASEIMAGE.out
	cd ..
	[ ! -d $BASEIMAGE ] && mkdir ${BASEIMAGE}
	cd ${BASEIMAGE}
	cat ../${IMGDIR}/${BASEIMAGE}.out-ramdisk.cpio|cpio -i
else
	echo "cannot found $IMGDIR/$BASEIMAGE"
fi
