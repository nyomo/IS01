#!/bin/sh
MKBOOTIMG=~/bin/mkbootimg
MKBOOTFS=~/bin/mkbootfs
BOOTFS=tmp_bootfs.img
BOOTIMG=tmp_bootimg.img
IMGDIR=./img
UBICONF=ubi.cfg
MKBOOTIMG_OPT="console=ttyMSM2,115200n8 androidboot.hardware=qcom"
KERNEL_IMG=$(echo $KERNEL_IMG)
BASEDIR=$*
[ -z $KERNEL_IMG ] && KERNEL="${IMGDIR}/$BASEDIR.out-kernel"
[ ! -z $KERNEL_IMG ] && KERNEL="${IMGDIR}/$KERNEL_IMG"

[ ! -d $IMGDIR ] && echo "error: do mkdir ./img" && exit
[ ! -f $UBICONF ]&& echo "error: UBICONF($UBICONF) notfound" && exit
[ ! -d $BASEDIR ]&& echo "usage: dir2img.sh targetdir"&&exit
[ ! -f $KERNEL ]&& echo "error: kernel($KERNEL) notfound" && exit

NEWFILE=${IMGDIR}/my_${BASEDIR} 
rm -r ramdisk
cp -a $BASEDIR ramdisk
echo "make ramdisk image with $KERNEL"
$MKBOOTFS ramdisk > $IMGDIR/$BOOTFS

$MKBOOTIMG --kernel $KERNEL --ramdisk $IMGDIR/$BOOTFS --cmdline "$MKBOOTIMG_OPT" --base 0x20000000 -o $IMGDIR/$BOOTIMG

echo "create $NEWFILE" 
rm -f $NEWFILE
ubinize -o $NEWFILE -p 128KiB -m 2048 -O 256 $UBICONF

