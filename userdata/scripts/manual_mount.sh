#!/usr/bin/env bash
#will not work as ./manual_mount.sh

fdisk -l
fdisk /dev/xvdi
	n (add a new partition)
	p (Partition type Primary)
	Choose default First sector and last sector
	-- it creats partition with type Linux
	t (change type)
	8e (Linux LVM)
	p
	w (save changes)
	// this will come out of fdisk cmd
lsblk (to find partition name)
partprobe /dev/xvdi1(informing kernel about drive change)
pvcreate /dev/xvdi1
pvs
vgcreate vg_01 /dev/xvdi1
vgs
lvcreate -n lv_01 -l 100%FREE vg_01
lvs
lvdisplay
mkfs.ext4 /dev/vg_01/lv_01
mkdir -p /data
echo "/dev/vg_01/lv_01 /data ext4 defaults 0 0" >> /etc/fstab
mount /data
df -h
---------------------
fdisk /dev/xvdh
	n
	p (default)
	1 (default)
	2048 (default)
	18874367 (default)
	t
	8e
	p
	w
partprobe /dev/xvdh1
pvcreate /dev/xvdh1
vgs
vgextend vg_01 /dev/xvdh1
vgs (you will see increase size by new disk )
lvcreate -L 100%FREE -n lv_02 vg_01
mkfs.ext4 /dev/vg_01/lv_02
mkdir /data2
echo "/dev/vg_01/lv_01 /data2 ext4 defaults 0 0" >> /etc/fstab
mount /data2