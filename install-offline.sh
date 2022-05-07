#!/bin/bash
#Grass!-Toolbox
if [[ $(whoami) != "root" ]];then
sudo bash $0
fi
mkdir /gtbox > /dev/null
cp ./gtbox.sh /gtbox/gtbox.sh
chmod 555 /gtbox/
ln -sf /gtbox/gtbox.sh /usr/bin/gtbox
