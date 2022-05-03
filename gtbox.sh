#!/bin/bash

less-help () {
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    echo "usage: $0 [options] COMMAND"
    echo ""
    echo "-h    --help      display a helpful usage message"
    echo ""
    echo "This is an interactive script,if no args are added, the default interaction mode."
}

root () {
    if [[ $(whoami) != "root" ]];then 
    su -c "$0"
    fi
}

help () {
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
}

plugin-add () {
    echo -e "\e[34mInstall a plugin\e[0m"
    echo -e "This command requires root privileges"
    root && plugin-add
    if test -f $1;then
    tar -xf $1 ~/$1-cache

    $PKG_NAME = $(grep "^architecture-" ~/$1-cache/plugin.cfg | sed 's/architecture-//')
    $PKG_ARCHITECTURE = $(grep "^architecture-" ~/$1-cache/plugin.cfg | sed 's/architecture-//')
    

    if [[ $(uname -m) == $(grep "^architecture-" ~/$1-cache/plugin.cfg | sed 's/architecture-//') || $(grep "^architecture-" ~/$1-cache/plugin.cfg | sed 's/architecture-//') == "all" ]];then echo "Check architecture [OK]";else echo "Check architecture [ERROR]" & exit 1;fi
    if [[ $(uname -o) == $(grep "^architecture-" ~/$1-cache/plugin.cfg | sed 's/architecture-//') || $(grep "^OS-" ~/$1-cache/plugin.cfg | sed 's/OS-//') == "all" ]];then echo "Check OS [OK]";else echo "Check OS [ERROR]" & exit 1;fi
    hash $(grep "^shell-" ~/$1-cache/plugin.cfg | sed 's/shell-//') > /dev/null 2>&1
    if [ "$?" == "0" ]; then echo "Check shell [OK]" ;else echo "Check shell [ERROR]" && exit;fi
    mkdir /opt/gtbox/$(grep "^name-" ~/$1-cache/plugin.cfg | sed 's/name-//')
    echo "$(grep "^shell-" ~/$1-cache/plugin.cfg | sed 's/shell-//')">>/opt/gtbox/$(grep "^name-" ~/$1-cache/plugin.cfg | sed 's/name-//')/shell
    echo "$(grep "^name-" ~/$1-cache/plugin.cfg | sed 's/name-//'):">>/opt/gtbox/toollist
    echo "$(grep "^info-" ~/$1-cache/plugin.cfg | sed 's/info-//')">>/opt/gtbox/toollist
    echo "$(grep "^start-" ~/$1-cache/plugin.cfg | sed 's/start-//')#/opt/gtbox/$(grep "^name-" ~/$1-cache/plugin.cfg | sed 's/name-//')/$(grep "^start-" ~/$1-cache/plugin.cfg | sed 's/start-//')">>/opt/gtbox/startlist
    cp ~/$1-cache /opt/$(grep "^name-" ~/$1-cache/plugin.cfg | sed 's/name-//')
    rm -rf ~/$1-cache
}

install-gtbox () {

}

ARGS () {

}

MAIN () {
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    read -p "()" $__run
    if [[ $(grep "^$__run#" /opt/gtbox/startlist | wc -l) -eq 1 ]];then
    $(cat /opt/gtbox/$__run/shell) $(grep "^$__run#" /opt/gtbox/startlist | sed s/$__run#//)
    else $__run
    fi
}