#!/bin/bash

# v1.0

LESS_HELP () {
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    echo "usage: $0 [options] COMMAND"
    echo ""
    echo "-h    --help      display a helpful usage message"
    echo ""
    echo "This is an interactive script,if no args are added, the default interaction mode."
    return 0
}

ROOT () {
    if [[ $(whoami) != "root" ]];then 
    su -c "$0"
    fi
    return 0
}

HELP () {
    echo -e "\e[34mBasic tools\e[0m"
    echo ""
    echo "help:"
    echo "Show a helpful usage message."
    echo "plugin-add [package]:"
    echo "Install plugins from local files."
    echo "plugin-remove [plugin-name]"
    echo "Removea plugin"
    echo "plugin-update [plugin-name] [package]"
    echo "Update or fix a plugin"
    echo "plugin-make [folders]:"
    echo "Make a plugin package"
    echo ""
    echo -e "\e[34mPlugin tools\e[0m"
    cat /opt/gtbox/toollist
    return 0
}

PLUGIN_ADD () {
    echo -e "\e[34mInstall a plugin\e[0m"
    echo -e "This command requires root privileges"
    ROOT && PLUGIN_ADD $*
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
    PKG_NAME=$(grep "^name-" ~/$1-cache/plugin.cfg | sed 's/name-//')
    PKG_INFO=$(grep "^info-" ~/$1-cache/plugin.cfg | sed 's/info-//')
    PKG_SHELL=$(grep "^shell-" ~/$1-cache/plugin.cfg | sed 's/shell-//')
    PKG_START=$(grep "^start-" ~/$1-cache/plugin.cfg | sed 's/start-//')

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
    echo "$PKG_NAME#$PKG_INFO">>/opt/gtbox/toollist
    echo "$PKG_NAME:$PKG_START">>/opt/gtbox/startlist
    return 0
}

PLUGIN_REMOVE () {
    echo -e "\e[34mRemove a plugin $1\e[0m"
    ROOT && PLUGIN_REMOVE $*
    if [[ 1 -gt $(grep "^$1:" /opt/gtbox/startlist | wc -l) ]];then echo "No such plugin" & exit 1;fi
    read -p "[Y/n]" TRUE_FALSE
    if [[ $TRUE_FALSE == "N" || $TRUE_FALSE == "n" ]];then exit 1
    else
    rm -rf /opt/gtbox/$1
    sed -i /^$1/d /opt/gtbox/startlist
    sed -i /^$1/d /opt/gtbox/toollist
    fi
    return 0
}

PLUGIN_UPDATE () {
    echo -e "\e[34mUpdate a plugin $1\e[0m"
    if [[ 1 -gt $(grep "^$1:" /opt/gtbox/startlist | wc -l) ]];then echo "No such plugin" & exit 1;fi
    read -p "[Y/n]" TRUE_FALSE
    if [[ $TRUE_FALSE == "N" || $TRUE_FALSE == "n" ]];then exit 1
    else
    PLUGIN-REMOVE $1 && PLUGIN_ADD $2
    fi
    return 0
}

PLUGIN_MAKE () {
    if test -d $1 ;then
    echo -e "\e[34mMake a plugin package\e[0m"
    else exit 1
    fi
    ROOT && PLUGIN_MAKE $*
    echo -e "\e[36mMake a configuration file\e[0m"
    echo "Cautions:"
    echo "1.Please note the path,the plugin will be installed to /opt/gtbox/[plugin name]/"
    echo "2.Plugin's name preferably without special characters and spaces."
    echo "3.Introduction should be short"
    #Basic Information
    read -p "Plugin name        :" MAKE_PKG_NAME
    read -p "Plugin introduction:" MAKE_PKG_INFO
    #Architecture
    echo "Select the architecture in which the plugin can run:"
    echo "1:all"
    echo "2:$(uname -m)"
    echo "3:Other"
    echo -e "\e[35m(default=1)\e[0m"
    read -p "Enter the number:" MAKE_PKG_IN1
    if [[ $MAKE_PKG_IN1 -eq 2 ]];then MAKE_PKG_UNAMEM=$(uname -m)
    elif [[ $MAKE_PKG_IN1 -eq 3 ]];then read -p "Enter the architecture:" MAKE_PKG_UNAMEM
    else MAKE_PKG_UNAMEM=all
    #OS
    echo "Select the OS in which the plugin can run:"
    echo "1:all"
    echo "2:$(uname -o)"
    echo "3:Other"
    echo -e "\e[35m(default=1)\e[0m"
    read -p "Enter the number:" MAKE_PKG_IN2
    if [[ $MAKE_PKG_IN2 -eq 2 ]];then MAKE_PKG_UNAMEM=$(uname -o)
    elif [[ $MAKE_PKG_IN2 -eq 3 ]];then read -p "Enter the OS:" MAKE_PKG_UNAMEO
    else MAKE_PKG_UNAMEM=all
    #Shell
    echo "Select the interpreter in which the plugin can run:"
    echo "1:bash"
    echo "2:Other"
    echo -e "\e[35m(default=1)\e[0m"
    read -p "Enter the number:" MAKE_PKG_IN3
    elif [[ $MAKE_PKG_IN3 -eq 2 ]];then read -p "Enter the OS:" MAKE_PKG_SHELL
    else MAKE_PKG_UNAMEM=bash
    #Start command
    echo "The script start command (absolute path), should be in the /opt/gtbox/$MAKE_PKG_NAME/ directory"
    echo "For example:bash /opt/gtbox/$MAKE_PKG_NAME/start.sh"
    read -p "Enter the start command:" MAKE_PKG_START
    #Other info
    echo "Enter some other information, such as the project URL"
    read -p "Other info:" MAKE_PKG_OTHER
    #Make
    echo "name-$MAKE_PKG_NAME">$1/plugin.cfg
    echo "info-$MAKE_PKG_INFO">>$1/plugin.cfg
    echo "architecture-$MAKE_PKG_UNAMEM">>$1/plugin.cfg
    echo "OS-$MAKE_PKG_UNAMEO">>$1/plugin.cfg
    echo "sh-$MAKE_PKG_SHELL">>$1/plugin.cfg
    echo "start-$MAKE_PKG_START">>$1/plugin.cfg
    echo "#$MAKE_PKG_OTHER">>$1/plugin.cfg
    tar -cJf $MAKE_PKG_NAME.tar.xz $1
    return 0
}

ARGS () {
    if [[ $1 == "--help" || $1 == "-h" ]];then
    LESS_HELP
    fi
    return 1
}

MAIN () {
    __EXIT=0
    while [[ $__EXIT -eq 0 ]]
    do
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    read -p "()" $__RUN
    if [[ $(grep "^$__RUN:" /opt/gtbox/startlist | wc -l) -eq 1 ]];then
    $(grep "^$__RUN:" /opt/gtbox/startlist | sed s/$__RUN://)
    else
    $__RUN
    fi
    done
    return 0
}

ARGS $*
if [[ $? = 1 ]];then exit 0;fi
MAIN