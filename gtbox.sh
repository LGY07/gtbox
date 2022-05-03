#!/bin/bash

less-help () {
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    echo "usage: $0 [options] COMMAND"
    echo ""
    echo "-h    --help      display a helpful usage message"
    echo ""
    echo "This is an interactive script,if no args are added, the default interaction mode."
}

ROOT () {
    if [[ $(whoami) != "root" ]];then 
    su -c "$0"
    fi
}

HELP () {
    echo -e "\e[34mBasic tools\e[0m"
    echo ""
    echo "help:"
    echo "Show a helpful usage message."
    echo "plugin-add [Package]:"
    echo "Installing plug-ins from local files."
    echo "plugin-maker [folders]:"
    echo "Make a plugin package"
    echo "plugin-update [plugin-name]"
    echo "Update a plugin"
    echo "plugin-config:"
    return 0
}

plugin-add () {
    echo -e "\e[34mInstall a plugin\e[0m"
    echo -e "This command requires root privileges"
    root && plugin-add
    #Check file
    if test -f $1;then
    tar -xf $1 ~/$1-cache
    else exit 1
    fi
    #Check architecture
    if [[ $(uname -m) == $(grep "^architecture-" ~/$1-cache/plugin.cfg | sed 's/architecture-//') || $(grep "^architecture-" ~/$1-cache/plugin.cfg | sed 's/architecture-//') == "all" ]];then
    echo -e "\033[32m[OK]\033[0m Check architecture"
    else echo -e "\033[31m[ERROR]\033[0mCheck architecture" & exit 1
    fi
    #Check OS
    if [[ $(uname -o) == $(grep "^OS-" ~/$1-cache/plugin.cfg | sed 's/OS-//') || $(grep "^OS-" ~/$1-cache/plugin.cfg | sed 's/OS-//') == "all" ]];then
    echo -e "\033[32m[OK]\033[0m Check OS"
    else echo -e "\033[31m[ERROR]\033[0mCheck OS" & exit 1
    fi

    #Check Configuration
    if [[ $(grep "^name-" ~/$1-cache/plugin.cfg | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi
    if [[ $(grep "^info-" ~/$1-cache/plugin.cfg | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi
    if [[ $(grep "^shell-" ~/$1-cache/plugin.cfg | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi
    if [[ $(grep "^start-" ~/$1-cache/plugin.cfg | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi

    #Vars
    $PKG_NAME = $(grep "^name-" ~/$1-cache/plugin.cfg | sed 's/name-//')
    $PKG_INFO = $(grep "^info-" ~/$1-cache/plugin.cfg | sed 's/info-//')
    $PKG_SHELL = $(grep "^shell-" ~/$1-cache/plugin.cfg | sed 's/shell-//')
    $PKG_START = $(grep "^start-" ~/$1-cache/plugin.cfg | sed 's/start-//')

    #Check name
    if [ $(grep "^$PKG_NAME" /opt/gtbox/startlist | wc -l) -eq 1 ];then
    echo -e "\033[31mPlugin name duplication\033[0m" & exit 1
    fi

    #Check shell
    hash $PKG_SHELL > /dev/null 2>&1
    if [[ "$?" == "0" ]];then
    echo -e "\033[32m[OK]\033[0m Check shell"
    else
    echo -e "\033[31m[ERROR]\033[0mCheck shell"
    echo -e "\033[31mPlease install $PKG_SHELL\033[0m"
    exit 1
    fi

    #Move to /opt/gtbox/
    mkdir /opt/gtbox/$PKG_NAME
    cp ~/$1-cache /opt/$PKG_NAME
    rm -rf ~/$1-cache

    #Add to list
    echo "$PKG_NAME">>/opt/gtbox/toollist
    echo "$PKG_INFO">>/opt/gtbox/toollist
    echo "$PKG_NAME:$PKG_START">>/opt/gtbox/startlist
}

ARGS () {
    if [[ $1 == "--help" || $1 == "-h" ]];then
    less-help
    fi
}

INSTALL () {
    ROOT
    mkdir /opt > /dev/null
    mkdir /opt/gtbox > /dev/null
    cp $0 /opt/gtbox/gtbox.sh > /dev/null
    ln -sf /opt/gtbox/gtbox.sh /usr/bin/gtbox > /dev/null
    return 0
}

MAIN () {
    __EXIT=0
    while [[ $__EXIT -eq 0 ]]
    do
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    read -p "()" $__RUN
    if [[ $(grep "^$__RUN#" /opt/gtbox/startlist | wc -l) -eq 1 ]];then
    $(grep "^$__RUN:" /opt/gtbox/startlist | sed s/$__RUN://)
    elif [[ $__RUN = "help" ]];then
    HELP
    else $__RUN
    fi
    done
}

ARGS $*
MAIN
