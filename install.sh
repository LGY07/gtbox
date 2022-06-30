#!/bin/bash
if [[ $(whoami) != "root" ]];then echo "Please run the scripts as root!"&exit;fi
if test -e ./gbsh.tar;then
tar -xf ./gbsh.tar
cp -rf gbsh ~/gbsh
else
mkdir ~/gbsh
cd ~/gbsh
curl -LO https://blog.lgy07.me/gtbox/lts/gbsh.sh
mkdir cache
mkdir pkgs
mkdir pkgs_path
mkdir plugins
curl -LO https://blog.lgy07.me/gtbox/lts/init.tar
tar -xf init.tar
rm init.tar
fi
ln -sf ~/gbsh.sh /usr/bin/gbsh