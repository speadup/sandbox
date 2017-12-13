#!/bin/sh
release=7.3.1611
arch=x86_64
force=0
opts=`getopt -a -o 67f --long 32,64,force -n "$0" -- "$@"`
[ $? == 0 ] || exit 1
eval set -- "${opts}"
unset opts
while true
do
    case "$1" in
    -f|--force) force=1;shift;;
    -6) release=6.8;shift;;
    -7) release=7.3.1611;shift;;
    --32) arch=i686;shift;;
    --64) arch=x86_64;shift;;
    --) shift; break;;
    *) echo "Internal error!" ;exit 1;;
    esac
done

rootdir=$1
[ -n "${rootdir}" ] || rootdir=centos-${release//.*/.x}
[ ${rootdir} != '.' -a -d ${rootdir} -a ${force} == 0 ] && { echo "rootdir ${rootdir} exists!";exit 1; }
[ ${rootdir} != '.' -a -d ${rootdir} -a ${force} == 1 ] && { rm -rf ${rootdir}; }

if [ ${release//.*} == 6 ]; then
    bootpkg="centos-release-${release/./-}.el6.centos.12.3.${arch}.rpm"
    booturl=http://vault.centos.org/${release}/os/${arch/i686/i386}/Packages/${bootpkg}
elif [  ${release//.*} == 7 ]; then
    bootpkg="centos-release-${release/./-}.el7.centos.${arch}.rpm"
    [ ${arch} == i686 ] && altarch=altarch/
    booturl=http://vault.centos.org/${altarch}${release}/os/${arch/i686/i386}/Packages/${bootpkg}
fi
echo $bootpkg
echo $booturl

umask 002

[ -n "${rootdir}" -a -n "${bootpkg}" ] || { echo "error:1"; exit 1; }
[ -n "${booturl}" ] && wget ${booturl} -O ${bootpkg}
[ -f "${bootpkg}" ] || { echo "error:2"; exit 2;  }
mkdir -p ${rootdir}
#rootdir=`cd ${rootdir};pwd`
#rpm -ivh --root=${rootdir} ${bootpkg}
rpm -ivh --root=`cd ${rootdir};pwd` ${bootpkg}
rm -f ${bootpkg}
touch ${rootdir}/etc/{fstab,resolv.conf}
mkdir -p ${rootdir}/dev/{mapper,shm,pts,net}
mkdir -p ${rootdir}/{opt,work}
mknod ${rootdir}/dev/null c 1 3
mknod ${rootdir}/dev/zero c 1 5
mknod ${rootdir}/dev/random c 1 8
mknod ${rootdir}/dev/urandom c 1 9
mknod ${rootdir}/dev/console c 5 1
mknod ${rootdir}/dev/rtc0 c 253 0
mknod ${rootdir}/dev/mapper/control c 10 58
mknod ${rootdir}/dev/net/tun c 10 200
mknod ${rootdir}/dev/loop0 b 7 0
mknod ${rootdir}/dev/loop1 b 7 1
mknod ${rootdir}/dev/loop2 b 7 2
mknod ${rootdir}/dev/loop3 b 7 3
mknod ${rootdir}/dev/loop4 b 7 4
mknod ${rootdir}/dev/loop5 b 7 5
mknod ${rootdir}/dev/loop6 b 7 6
mknod ${rootdir}/dev/loop7 b 7 7
ln -s rtc0 ${rootdir}/dev/rtc
ln -s /proc/self/fd ${rootdir}/dev/fd
ln -s /proc/self/fd/2 ${rootdir}/dev/stderr
ln -s /proc/self/fd/1 ${rootdir}/dev/stdout
ln -s /proc/self/fd/0 ${rootdir}/dev/stdin
