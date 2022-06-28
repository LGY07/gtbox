#!/bin/bash
if [ "$?" != "0" ]; then
    echo -e "\033[31mERROR:\033[0mPlease make sure curl is installed"
    echo -e "\033[33mDo you want to try installing curl?\033[0m"
    read -p "[Y/n](default=n)" install
    if [[ $install == "Y" || $install == "y" ]];then
        hash dnf > /dev/null 2>&1
        if [ "$?" == "0" ]; then dnf check-update -y;sudo dnf install curl -y || echo "Please install curl." && __CHECK=ERROR
        fi
        hash pacman > /dev/null 2>&1
        if [ "$?" == "0" ]; then sudo pacman -Sy curl --noconfirm || echo "Please install curl." && __CHECK=ERROR
        fi
        hash apt-get > /dev/null 2>&1
        if [ "$?" == "0" ]; then apt-get update -y;sudo apt-get install curl -y || echo "Please install curl." && __CHECK=ERROR
        fi
    else echo "Please install curl." && __CHECK=ERROR
    fi
exit
fi
if [ "$?" != "0" ]; then
    echo -e "\033[31mERROR:\033[0mPlease make sure tar is installed"
    echo -e "\033[33mDo you want to try installing tar?\033[0m"
    read -p "[Y/n](default=n)" install
    if [[ $install == "Y" || $install == "y" ]];then
        hash dnf > /dev/null 2>&1
        if [ "$?" == "0" ]; then dnf check-update -y;sudo dnf install tar -y || echo "Please install tar." && __CHECK=ERROR
        fi
        hash pacman > /dev/null 2>&1
        if [ "$?" == "0" ]; then sudo pacman -Sy tar --noconfirm || echo "Please install tar." && __CHECK=ERROR
        fi
        hash apt-get > /dev/null 2>&1
        if [ "$?" == "0" ]; then apt-get update -y;sudo apt-get install tar -y || echo "Please install tar." && __CHECK=ERROR
        fi
    else echo "Please install tar." && __CHECK=ERROR
    fi
exit
fi