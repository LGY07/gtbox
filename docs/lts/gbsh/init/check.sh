#!/bin/bash
#CheckInstall
#__CheckInstall SomePKG inDNF inPacman inAPT
__CheckInstall() {
if [ "$?" != "0" ]; then
    echo -e "\033[31mERROR:\033[0mPlease make sure $1 is installed"
    echo -e "\033[33mDo you want to try installing $1?\033[0m"
    read -p "[Y/n](default=n)" install
    if [[ $install == "Y" || $install == "y" ]];then
        hash dnf > /dev/null 2>&1
        if [ "$?" == "0" ]; then dnf check-update -y;sudo dnf install $2 -y || echo "Please install $1." && __CHECK=ERROR
        fi
        hash pacman > /dev/null 2>&1
        if [ "$?" == "0" ]; then sudo pacman -Sy $3 --noconfirm || echo "Please install $1." && __CHECK=ERROR
        fi
        hash apt-get > /dev/null 2>&1
        if [ "$?" == "0" ]; then apt-get update -y;sudo apt-get install $4 -y || echo "Please install $1." && __CHECK=ERROR
        fi
    else echo "Please install $1." && __CHECK=ERROR
    fi
exit
fi
}
#Check curl
__CheckInstall curl curl curl curl
#Check tar
__CheckInstall tar tar tar tar