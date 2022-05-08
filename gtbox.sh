#!/bin/bash

# v0.1-alpha

LESS_HELP () {
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    echo "usage: $0 [options] COMMAND"
    echo ""
    echo "-h    --help      display a helpful usage message"
    echo "-r    --run       run a tool without interactivity"
    echo ""
    echo "This is an interactive script,if no args are added, the default interaction mode."
    return 0
}

CHECK_wget () {
hash wget > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo -e "\033[31mERROR:\033[0mPlease make sure wget is installed"
    echo -e "\033[33mDo you want to try installing wget?\033[0m"
    read -p "[Y/n](default=n)" install
    if [[ $install == "Y" || $install == "y" ]];then
        hash dnf > /dev/null 2>&1
        if [ "$?" == "0" ]; then dnf check-update -y;sudo dnf install wget -y
        fi
        hash pacman > /dev/null 2>&1
        if [ "$?" == "0" ]; then sudo pacman -Sy wget --noconfirm
        fi
        hash apt-get > /dev/null 2>&1
        if [ "$?" == "0" ]; then apt-get update -y;sudo apt-get install wget -y
        fi
    fi
exit
fi
}

CHECK_tar () {
hash tar > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo -e "\033[31mERROR:\033[0mPlease make sure tar is installed"
    echo -e "\033[33mDo you want to try installing tar?\033[0m"
    read -p "[Y/n](default=n)" install
    if [[ $install == "Y" || $install == "y" ]];then
        hash dnf > /dev/null 2>&1
        if [ "$?" == "0" ]; then dnf check-update -y;sudo dnf install tar -y
        fi
        hash pacman > /dev/null 2>&1
        if [ "$?" == "0" ]; then sudo pacman -Sy tar --noconfirm
        fi
        hash apt-get > /dev/null 2>&1
        if [ "$?" == "0" ]; then apt-get update -y;sudo apt-get install tar -y
        fi
    fi
exit
fi
}

help () {
    echo -e "\e[34mBasic tools\e[0m"
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
    cat /gtbox/toollist
    echo ""
    return 0
}

plugin-add () {
    echo -e "\e[34mInstall a plugin\e[0m"
    echo -e "This command requires root privileges"
    CHECK_tar
    if [[ $(whoami) != "root" ]];then echo -e "\033[31mPermission denied\033[0m" & exit 1;fi
    #Check file
    if [[ $(tar -tf $1 | grep "plugin.cfg" | wc -l) -eq 1 ]];then
    ADD_PATH=$(tar -tf $1 | grep "plugin.cfg")
    tar -xf $1 -C ~/
    else exit 1
    fi
    #Check architecture
    if [[ $(uname -m) == $(grep "^architecture-" ~/$ADD_PATH | sed 's/architecture-//') || $(grep "^architecture-" ~/$ADD_PATH | sed 's/architecture-//') == "all" ]];then
    echo -e "\033[32m[OK]\033[0m Check architecture"
    else echo -e "\033[31m[ERROR]\033[0mCheck architecture" & exit 1
    fi
    #Check OS
    if [[ $(uname -o) == $(grep "^OS-" ~/$ADD_PATH | sed 's/OS-//') || $(grep "^OS-" ~/$ADD_PATH | sed 's/OS-//') == "all" ]];then
    echo -e "\033[32m[OK]\033[0m Check OS"
    else echo -e "\033[31m[ERROR]\033[0mCheck OS" & exit 1
    fi

    #Check Configuration
    if [[ $(grep "^name-" ~/$ADD_PATH | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi
    if [[ $(grep "^info-" ~/$ADD_PATH | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi
    if [[ $(grep "^shell-" ~/$ADD_PATH | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi
    if [[ $(grep "^start-" ~/$ADD_PATH | wc -l) -ne 1 ]];then echo -e "\033[31mThe configuration file is wrong\033[0m" & exit 1;fi

    #Vars
    PKG_NAME=$(grep "^name-" ~/$ADD_PATH | sed 's/name-//')
    PKG_INFO=$(grep "^info-" ~/$ADD_PATH | sed 's/info-//')
    PKG_SHELL=$(grep "^shell-" ~/$ADD_PATH | sed 's/shell-//')
    PKG_START=$(grep "^start-" ~/$ADD_PATH | sed 's/start-//')

    #Check name
    if [ $(grep "^$PKG_NAME" /gtbox/startlist | wc -l) -eq 1 ];then
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

    #Move to /gtbox/
    mkdir /gtbox/$PKG_NAME
    cp ~/$1-cache /opt/$PKG_NAME
    rm -rf ~/$1-cache

    #Add to list
    echo "$PKG_NAME#$PKG_INFO">>/gtbox/toollist
    echo "$PKG_NAME:$PKG_START">>/gtbox/startlist
    return 0
}

plugin-remove () {
    echo -e "\e[34mRemove a plugin $1\e[0m"
    if [[ $(whoami) != "root" ]];then echo -e "\033[31mPermission denied\033[0m" & exit 1;fi
    if [[ 1 -gt $(grep "^$1:" /gtbox/startlist | wc -l) ]];then echo "No such plugin" & exit 1;fi
    read -p "[Y/n]" TRUE_FALSE
    if [[ $TRUE_FALSE == "N" || $TRUE_FALSE == "n" ]];then exit 1
    else
    rm -rf /gtbox/$1
    sed -i /^$1/d /gtbox/startlist
    sed -i /^$1/d /gtbox/toollist
    fi
    return 0
}

plugin-update () {
    echo -e "\e[34mUpdate a plugin $1\e[0m"
    if [[ 1 -gt $(grep "^$1:" /gtbox/startlist | wc -l) ]];then echo "No such plugin" & exit 1;fi
    read -p "[Y/n]" TRUE_FALSE
    if [[ $TRUE_FALSE == "N" || $TRUE_FALSE == "n" ]];then exit 1
    else
    plugin-remove $1 && plugin-add $2
    fi
    return 0
}

plugin-make () {
    if test -d $1 ;then
    echo -e "\e[34mMake a plugin package\e[0m"
    else exit 1
    fi
    if [[ $(whoami) != "root" ]];then echo -e "\033[31mPermission denied\033[0m" & exit 1;fi
    CHECK_tar
    echo -e "\e[36mMake a configuration file\e[0m"
    echo "Cautions:"
    echo "1.Please note the path,the plugin will be installed to /gtbox/[plugin name]/"
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
    fi
    #OS
    echo "Select the OS in which the plugin can run:"
    echo "1:all"
    echo "2:$(uname -o)"
    echo "3:Other"
    echo -e "\e[35m(default=1)\e[0m"
    read -p "Enter the number:" MAKE_PKG_IN2
    if [[ $MAKE_PKG_IN2 -eq 2 ]];then MAKE_PKG_UNAMEO=$(uname -o)
    elif [[ $MAKE_PKG_IN2 -eq 3 ]];then read -p "Enter the OS:" MAKE_PKG_UNAMEO
    else MAKE_PKG_UNAMEO=all
    fi
    #Shell
    echo "Select the interpreter in which the plugin can run:"
    echo "1:bash"
    echo "2:Other"
    echo -e "\e[35m(default=1)\e[0m"
    read -p "Enter the number:" MAKE_PKG_IN3
    if [[ $MAKE_PKG_IN3 -eq 2 ]];then read -p "Enter the OS:" MAKE_PKG_SHELL
    else MAKE_PKG_SHELL=bash
    fi
    #Start command
    echo "The script start command (absolute path), should be in the /gtbox/$MAKE_PKG_NAME/ directory"
    echo "For example:bash /gtbox/$MAKE_PKG_NAME/start.sh"
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
    if [[ $(tar -tf $MAKE_PKG_NAME.tar.xz | grep "plugin.cfg" | wc -l) -eq 1 ]];then
    return 0
    else
    rm -rf $MAKE_PKG_NAME.tar.xz
    fi
}

ARGS () {
    if [[ $1 == "--help" || $1 == "-h" ]];then
    LESS_HELP
    return 1
    else
    return 0
    fi
    if [[ $1 == "--run" ]];then
    $(echo $* | sed 's/--run //') & return 1
    fi
    if [[ $1 == "-r" ]];then
    $(echo $* | sed 's/-r //') & return 1
    fi
}

MAIN () {
    __EXIT=0
    while [[ $__EXIT -eq 0 ]]
    do
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    read -p "()" __RUN
    if [[ $(grep "^$__RUN:" /gtbox/startlist | wc -l) -eq 1 ]];then
    $(grep "^$__RUN:" /gtbox/startlist | sed s/$__RUN://)
    elif [[ $__RUN == "exit" ]]; 
    then echo -e "\033[31mGood bye!\033[0m" & __EXIT=1
    else
    $__RUN
    fi
    done
    return 0
}

ARGS $*
if [[ $? = 1 ]];then exit $?;fi
echo "Enter help for help"
MAIN