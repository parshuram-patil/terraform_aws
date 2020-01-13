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
lvcreate -L 9G -n lv_01 vg_01
lvs
lvdisplay
mkfs.ext4 /dev/vg_01/lv_01
mkdir -p /data
mount /dev/vg_01/lv_01 /data
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
lvcreate -L 9G -n lv_02 vg_01
mkfs.ext4 /dev/vg_01/lv_02
mkdir /data2
mount /dev/vg_01/lv_02 /data2/