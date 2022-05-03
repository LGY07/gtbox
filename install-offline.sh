#!/bin/bash
if [[ $(whoami) != "root" ]];then
sudo bash $0
fi
mkdir /opt > /dev/null
mkdir /opt/gtbox > /dev/null
cp ./gtbox.sh /opt/gtbox/gtbox.sh
chmod 555 /opt/gtbox/gtbox.sh
ln -sf /opt/gtbox/gtbox.sh /usr/bin/gtbox
