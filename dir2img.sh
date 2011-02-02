#!/bin/sh
UNUBINIZE=unubinize.pl
SPLIT_BOOTIMAGE=split_bootimg.pl
MKBOOTIMG=mkbootimg
MKBOOTFS=mkbootfs
BOOTFS=bootfs_tmp.img
IMGDIR=./img
UBICONF=ubi.cfg
MKBOOTIMG_OPT="console=ttyMSM2,115200n8 androidboot.hardware=qcom"
KERNEL="${IMGDIR}/$BASEDIR.out-kernel"

BASEDIR=$*
[ ! -d $IMGDIR ] && echo "error: do mkdir ./img" && exit
[ ! -f $UBICONF ]&& echo "error: UBICONF($UBICONF) notfound" && exit
[ ! -d $BASEDIR ]&& echo "usage: dir2img.sh targetdir"&&exit
[ ! -f $KERNEL ]&& echo "error: kernel($KERNEL) notfound" && exit

NEWFILE=${IMGDIR}/my_${BASEDIR} 
$MKBOOTFS $BASEDIR > ${IMGDIR}/${BOOTFS} && \
$MKBOOTIMG --kernel $KERNEL --ramdisk ${IMGDIR}/$BOOTFS --cmdline "'$MKBOOTIMG_OPT'" --base 0x20000000 -o $NEWFILE \
&& echo "create $NEWFILE" 

