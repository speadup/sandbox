#!/bin/sh
rootdir=$1
umount $rootdir/work
umount $rootdir/proc
umount $rootdir/sys
umount $rootdir/dev/pts
umount $rootdir/dev/shm
