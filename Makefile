RO215DIR=../is01gb/ro215is01_2.3.1-r1_v3_20110201-01/
CUSTOMDIR=../is01gb/
DATA_GB=data_ginger
SYSTEM_GB=system_ginger
ADB=adb
SYSTEM_16GB="asg bin etc fonts lib media pubkey sb userdata usr build.prop ts.conf"
all:;@echo "read README.utf8 and  make -k target "

install:preinstall copy_gb_system push_gb push_gb_bootimage_msg

custom_gb:
	$(ADB) shell busybox chmod 777 /data/$(SYSTEM_GB)/system/bin/busybox
	$(ADB) shell busybox chmod 777 /data/$(SYSTEM_GB)/system/etc/sdio
	

depend:
#	@echo "check adb command ";if test -x $(ADB) ;then echo Ok;else echo NG;fi
	@echo "check binary ";if test -d $(RO215DIR) ;then echo Ok;else echo NG;fi
	$(ADB) shell mount_data
	$(ADB) shell mount_system

preinstall:
	$(ADB) shell busybox mkdir -p /data/$(SYSTEM_GB)/system
	$(ADB) shell busybox mkdir -p /data/$(DATA_GB)/data

clean:
	$(ADB) shell busybox rm -r /data/$(SYSTEM_GB)/system
	$(ADB) shell busybox rm -r /data/$(DATA_GB)/data

copy_gb_system:
	@LIST=$(SYSTEM_16GB); \
	for i in $$LIST ; do \
	echo "copying system/$$i"; \
	$(ADB) shell busybox cp -a /system2/$$i /data/$(SYSTEM_GB)/system/ ; \
	done 
	$(ADB) shell busybox cp -a /data/misc /data/$(DATA_GB)/data/misc/ 
	$(ADB) shell busybox cp -a /data/ro /data/$(DATA_GB)/data/

push_gb:push_gb_data push_gb_system

push_gb_system:
	$(ADB) push $(RO215DIR)system/ /data/$(SYSTEM_GB)/system
	$(ADB) push $(RO215DIR)app/ /data/$(SYSTEM_GB)/system/app
	#$(ADB) push $(RO215DIR)init.qcom.rc /data/$(SYSTEM_GB)/system
	#$(ADB) push $(RO215DIR)sdio.sh /data/$(SYSTEM_GB)/system/bin

push_gb_data:
	$(ADB) push $(RO215DIR)data/ /data/$(DATA_GB)/data
	$(ADB) shell busybox sed -i '1a ctrl_interface=DIR=/data/misc/wifi/sockets' /data/$(DATA_GB)/data/misc/wifi/wpa_supplicant.conf

push_gb_bootimage:
	$(ADB) push $(RO215DIR)gingerbread_v3.img /data/$(DATA_GB)/
	$(ADB) shell flash_image recovery /data/$(DATA_GB)/gingerbread_v3.img
push_gb_bootimage_msg:
	@echo "make -n push_gb_bootimage"

