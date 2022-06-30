#!/bin/bash
_upgrade() {
    if [[ $(curl -L https://blog.lgy07.me/gtbox/$RELEASES/version.txt) != $VERSION ]];then
    mkdir $CFG_PATH/cache/upgrade
    __PWD=$(pwd)
    cd $CFG_PATH/cache/upgrade
    curl -LO https://blog.lgy07.me/gtbox/$RELEASES/gbsh.sh
    curl -LO https://blog.lgy07.me/gtbox/$RELEASES/init.tar
    tar -xf init.tar
    rm -f init.tar
    cp -rf init $CFG_PATH/init
    cp -f gbsh.sh $CFG_PATH/gbsh.sh 
    fi
    .clean
    return 0
}
_clean() {
    rm -rf $CFG_PATH/cache/*>/dev/null
    rm -f $CFG_PATH/cache/*>/dev/null
}