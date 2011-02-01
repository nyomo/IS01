RO215DIR=../is01gb/ro215is01_2.3.1-r1_v3_20110201-01/
CUSTOMDIR=../is01gb/
ADB=adb
SYSTEM_DOUNUT="app asg bin etc fonts framework lib media pubkey sb uerdata usr build.prop ts.conf"
DATA_DOUNUT="anr app app-private asg cache dalvik-cache data fonts fota gps-test kernel-tests local media misc property remote-api-tets ro rpc-tests sb synergy system local.prop"
SYSTEM_GB="asg bin etc fonts lib media pubkey sb userdata usr build.prop ts.conf"
all:;@echo "read README.utf and  make -k target "

install:preinstall copy_gb_system push_gb push_gb_bootimage_msg

custom_gb:
	$(ADB) push $(CUSTOMDIR)busybox /data/system_ginger/system/bin
	$(ADB) shell busybox chmod 777 /data/system_ginger/system/bin
	

depend:
#	@echo "check adb command ";if test -x $(ADB) ;then echo Ok;else echo NG;fi
	@echo "check binary ";if test -d $(RO215DIR) ;then echo Ok;else echo NG;fi
	$(ADB) shell mount_data
	$(ADB) shell mount_system

preinstall:
	$(ADB) shell busybox mkdir -p /data/system_ginger/system
	$(ADB) shell busybox mkdir -p /data/data_ginger/data

clean:
	$(ADB) shell busybox rm -r /data/system_ginger/system
	$(ADB) shell busybox rm -r /data/data_ginger/data

copy_gb_system:
	@LIST=$(SYSTEM_GB); \
	for i in $$LIST ; do \
	echo "copying system/$$i"; \
	$(ADB) shell busybox cp -a /system2/$$i /data/system_ginger/system/ ; \
	done 
	$(ADB) shell busybox cp -a /data/misc /data/data_ginger/data/misc/ 
	$(ADB) shell busybox cp -a /data/ro /data/data_ginger/data/

push_gb:push_gb_data push_gb_system

push_gb_system:
	$(ADB) push $(RO215DIR)system/ /data/systen_ginger/system
	$(ADB) push $(RO215DIR)app/ /data/system_ginger/system/app
	#$(ADB) push $(RO215DIR)init.qcom.rc /data/system_ginger/system
	#$(ADB) push $(RO215DIR)sdio.sh /data/system_ginger/system/bin

push_gb_data:
	$(ADB) push $(RO215DIR)data/ /data/data_ginger/data
	$(ADB) shell busybox sed -i '1a ctrl_interface=DIR=/data/misc/wifi/sockets' /data/data_ginger/data/misc/wifi/wpa_supplicant.conf

push_gb_bootimage:
	$(ADB) push $(RO215DIR)gingerbread_v3.img /data/data_ginger/
	$(ADB) shell flash_image recovery /data/data_ginger/gingerbread_v3.img
push_gb_bootimage_msg:
	@echo "make -n push_gb_bootimage"

