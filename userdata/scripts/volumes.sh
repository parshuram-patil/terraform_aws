#!/bin/bash

# wait for drive attachment
sleep 30

set -ex 

vgchange -ay

#DRIVES="/dev/xvdh /dev/xvdi"
echo ${DRIVES}
COUNTER=0

for DRIVE in ${DRIVES}
do
	#echo $DRIVE
	DEVICE_FS=`blkid -o value -s TYPE $DRIVE || echo ""`
	if [[ "`echo -n $DEVICE_FS`" == "" ]] ; then
		# wait for the device to be attached
		DEVICE_NAME=`echo "$DRIVE" | awk -F '/' '{print $3}'`
		DEVICE_EXISTS=''
		while [[ -z $DEVICE_EXISTS ]]; do
			echo "checking $DEVICE_NAME"
			DEVICE_EXISTS=`lsblk |grep "$DEVICE_NAME" |wc -l`
			if [[ $DEVICE_EXISTS != "1" ]]; then
			  sleep 15
			  echo "device $DEVICE_NAME not found"
			fi
		done
	fi

	COUNTER=$((COUNTER+1))
	VG_NAME=data$COUNTER
	if [[ $DEVICE_EXISTS == "1" ]];
	then
		#echo $VG_NAME
		LV_NAME=volume$COUNTER
		pvcreate $DRIVE
		vgcreate $VG_NAME $DRIVE
		lvcreate --name $LV_NAME -l 100%FREE $VG_NAME
		mkfs.ext4 /dev/$VG_NAME/$LV_NAME

		mkdir -p /$VG_NAME
		echo "/dev/$VG_NAME/$LV_NAME /$VG_NAME ext4 defaults 0 0" >> /etc/fstab
		mount /$VG_NAME
		MESSAGE="Failure"
		if [ $? -eq 0 ]; then
			MESSAGE="Success"
		fi
		echo "drive $DRIVE mounting $MESSAGE!!!"
	fi
done
