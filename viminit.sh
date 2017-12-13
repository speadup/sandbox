#!/bin/sh
bindir=`dirname $0`
rootdir=$1
umask 002
[ -f ${rootdir}/etc/centos-release ] || exit 1
[ -d /opt/vim-bundle/bundles/Vundle.vim ] && exit 1 

echo 'source /opt/vim-bundle/vimrc' >~/.vimrc
mkdir -p /opt/vim-bundle/bundles
cp -f ${bindir}/vimrc /opt/vim-bundle/  
git clone https://github.com/VundleVim/Vundle.vim /opt/vim-bundle/bundles/Vundle.vim
vim -c:PluginInstall
