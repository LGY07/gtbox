#!/bin/bash
#Grass!-Toolbox
if [[ $(whoami) != "root" ]];then
sudo bash $0
fi
mkdir -p /opt/gtbox > /dev/null
cp ./gtbox.sh /opt/gtbox/gtbox.sh
chmod 555 /opt/gtbox/
ln -sf /opt/gtbox/gtbox.sh /usr/bin/gtbox
