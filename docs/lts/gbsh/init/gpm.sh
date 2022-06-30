#!/bin/bash
#Grass! PKG Manager
_make () {
    if test -d $1;then echo "Make a PKG";else echo "Can't find $1!"&exit 1;fi
    mkdir $CFG_PATH/cache/make.$1
    cp $1 $CFG_PATH/cache/make.$1
    read -p "Name of the pkg:" MAKE_PKG_NAME
    if [[ $MAKE_PKG_NAME = "" ]];then exit 1;fi
    read -p "Where is the main scripts in $1(such as launcher.sh):" MAKE_PKG_LAUNCHER
    read -p "Where is the help file in $1(such as help.txt):" MAKE_PKG_HELP
    read -p "Dependencies of the pkg (such as bash):" MAKE_PKG_DEPEND
    read -p "How to install dependency by DNF(pkgs' name in RHEL/Fedora):" MAKE_PKG_DNF
    read -p "How to install dependency by Pacman(pkgs' name in ArchLinux):" MAKE_PKG_PACMAN
    read -P "How to install dependency by APT(pkgs' name in Debian/Ubuntu):" MAKE_PKG_APT
    read -p "Update url:" MAKE_PKG_URL
    if test -e $CFG_PATH/cache/make.$1/$MAKE_PKG_LAUNCHER;then :;else exit;fi
    if test -e $CFG_PATH/cache/make.$1/$MAKE_PKG_HELP;then BOOL=Y
    else
    echo -e "\e[0m;33mWARNING:Can't find the help file，do you wish to continue?\e[0m"
    read -p "[Y/n((default=Y)]" __BOOL
    fi
    case $__BOOL in
    Y)  :
    ;;
    y)  :
    ;;
    N)  exit 1
    ;;
    n)  exit 1
    esac
    echo "Making pkg..."
    echo '['$(New-Guid)']'>$CFG_PATH/cache/make.$1/pkg.ini
    echo "MAKE_PKG_NAME=$MAKE_PKG_NAME">>$CFG_PATH/cache/make.$1/pkg.ini
    echo "MAKE_PKG_LAUNCHER=$MAKE_PKG_LAUNCHER">>$CFG_PATH/cache/make.$1/pkg.ini
    echo "MAKE_PKG_HELP=$MAKE_PKG_HELP">>$CFG_PATH/cache/make.$1/pkg.ini
    echo "MAKE_PKG_DEPEND=$MAKE_PKG_DEPEND">>$CFG_PATH/cache/make.$1/pkg.ini
    echo "MAKE_PKG_DNF=$MAKE_PKG_DNF">>$CFG_PATH/cache/make.$1/pkg.ini
    echo "MAKE_PKG_PACMAN=$MAKE_PKG_PACMAN">>$CFG_PATH/cache/make.$1/pkg.ini
    echo "MAKE_PKG_APT=$MAKE_PKG_APT">>$CFG_PATH/cache/make.$1/pkg.ini
    if [[ $MAKE_PKG_URL == "" ]];
    then echo MAKE_PKG_URL=disable>>$CFG_PATH/cache/make.$1/pkg.ini
    else "echo MAKE_PKG_URL=$MAKE_PKG_URL">>$CFG_PATH/cache/make.$1/pkg.ini
    mv $CFG_PATH/cache/make.$1/ $CFG_PATH/cache/$MAKE_PKG_NAME
    tar -cf $CFG_PATH/cache/"$MAKE_PKG_NAME".tar $CFG_PATH/cache/$MAKE_PKG_NAME
    rm -rf $CFG_PATH/cache/$MAKE_PKG_NAME
    mv $CFG_PATH/cache/"$MAKE_PKG_NAME".tar ~/"$MAKE_PKG_NAME".grass.tar && echo "Done! the pkg $MAKE_PKG_NAME is in ~/$MAKE_PKG_NAME"
    return 0
}
_install() {
    #clean
    rm -rf $CFG_PATH/cache/.load > /dev/null
    rm -rf $CFG_PATH/cache/_install > /dev/null
    _INSTALL__SEC1_MAKE_PKG_NAME=
    _INSTALL__SEC1_MAKE_PKG_HELP=
    _INSTALL__SEC1_MAKE_PKG_DEPEND=
    _INSTALL__SEC1_MAKE_PKG_DNF=
    _INSTALL__SEC1_MAKE_PKG_PACMAN=
    _INSTALL__SEC1_MAKE_PKG_APT=
    _INSTALL__SEC1_MAKE_PKG_URL=
    _INSTALL__SEC1_MAKE_PKG_LAUNCHER=
    #load
    mkdir $CFG_PATH/cache/.load
    mkdir $CFG_PATH/cache/_install
    if [[ $(echo $1 | grep "^http" | wc -l) -eq 1 ]];then
    echo "Install a pkg online!"
    __PWD=$(pwd)
    cd $CFG_PATH/cache/.load
    curl -LO $1
    elif test -e $1;then
    echo "Install a local pkg!"
    cp $1 $CFG_PATH/cache/.load/$1
    cd $CFG_PATH/cache/.load
    else
    echo "Can't find $1!" & exit 1
    fi
    ini_Path=$(tar -tf $(ls) | grep /pkg.ini$)
    tar -xf $(ls) -C $CFG_PATH/cache/_install
    cd $CFG_PATH/cache/_install
    rm -rf $CFG_PATH/cache/.load
    INI_Read $CFG_PATH/cache/.load/$ini_Path INSTALL
    CACHE_Path=$CFG_PATH/cache/_install/$(ls)
    cd $__PWD
    #Install
    mkdir $CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME
    cp $CACHE_Path/* $CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/*
    ln $CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/$_INSTALL__SEC1_MAKE_PKG_LAUNCHER $CFG_PATH/pkgs_path/grass.$_INSTALL__SEC1_MAKE_PKG_NAME
    rm -rf $CFG_PATH/cache/_install
    echo '['$(New-Guid)']'>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_NAME>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_LAUNCHER>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_HELP>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_DEPEND>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_DNF>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_PACMAN>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_APT>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    echo $MAKE_PKG_URL>>$CFG_PATH/pkgs/$_INSTALL__SEC1_MAKE_PKG_NAME/pkg.ini
    return 0
}
_remove() {
    if [[ $(ls -l $CFG_PATH/pkgs | grep " $1$") -eq 1 ]]
    then echo "Remove $1!"
    else echo "Can't find $1!" & exit 1
    fi
    rm -f $CFG_PATH/pkgs_path/$1
    rm -rf $CFG_PATH/pkgs/$1
    return 0
}
_update() {
    if [[ $(ls -l $CFG_PATH/pkgs | grep " $1$") -eq 1 ]]
    then echo "Update $1!"
    else echo "Can't find $1!" & exit 1
    fi
    _UPDATE__SEC1_MAKE_PKG_URL=disable
    INI_Read $CFG_PATH/pkgs/$1/pkg.ini UPDATE
    if [[ $_UPDATE__SEC1_MAKE_PKG_URL == "disable" ]];then
    echo "$1 has no updated link!" & exit 0
    else
    rm -rf $CFG_PATH/cache/download>/dev/null
    mkdir $CFG_PATH/cache/download
    __PWD=$(pwd)
    cd $CFG_PATH/cache/download
    curl -LO $_UPDATE__SEC1_MAKE_PKG_URL
    if [[ $? -eq 0 ]];then : ;else echo "Can't download $1!" & exit 1;fi
    __Updatepkg=$CFG_PATH/cache/download/$(ls $CFG_PATH/cache/download)
    _remove $1
    _install __Updatepkg
    if [[ $? -eq 0 ]];then
    echo "Update $1 successfully!"
    return 0
    else echo "Fail to update $1!"
    return 1
}
_update-all() {
    rm -f $CFG_PATH/cache/update.txt>/dev/null
    ls -1 $CFG_PATH/pkgs/>$CFG_PATH/cache/update.txt
    for UPDATENAME in $CFG_PATH/cache/update.txt
    do
    _update $UPDATENAME
    return %?
    done
    rm -f $CFG_PATH/cache/update.txt
    return 0
}
_list() {
    ls -1 $CFG_PATH/pkgs/
    return 0
}