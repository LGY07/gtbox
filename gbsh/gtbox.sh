#!/bin/bash

if test -e /etc/gbsh/gbsh.cfg
    then source /etc/gbsh/gbsh.cfg
    else source ~/gbsh/gbsh.cfg || exit 1
fi

_INITS=( $(ls -1 $CFG_PATH) )
for _INIT in ${_INITS}
do
source $CFG_PATH/init/$_INIT
done

ARGS_MODE() {
    case $1 in
        --help) HELP_ARG ; return 2
        ;;
        -h) HELP_ARG ; return 2
        ;;
        --run)  $(echo $* | sed 's/--run //') ; return 2
        ;;
        -r) $(echo $* | sed 's/-r //') ; return 2
        ;;
        --version)  echo $VERSION
        ;;
        -v) echo $VERSION
        ;;
        *)  return 0
        ;;
    esac
}
MAIN() {
echo 'Type gbsh-help for help.'
__EXIT=0
while [[ $__EXIT -eq 0 ]]
do
    if [[ $(whoami) == "root" ]];
    then __WHO="[root@$(cat /etc/hostname) $(pwd)]-GrassShell#"
    else __WHO="[$(whoami)@$(cat /etc/hostname) $(pwd)]-GrassShell$"
    fi
        echo -e "\033[32mGrass-Bash!!!\033[0m"
        read -p "$__WHO"  __RUN
        if [[ $__RUN == "grass" ]];
                then echo -e "\033[33mGrassGrassGrass!!!\033[0m"
        elif [[ $__RUN == "exit" ]]; 
                then echo -e "\033[31mGood bye!\033[0m" & exit 0
        else $__RUN
        fi
done
}

_PLUGINS=( $(ls -1 $PLUGIN_PATH) )
for _PLUGIN in ${_PLUGINS}
do
source $PLUGIN_PATH/_PLUGIN
done

_INITS=( $(ls -1 $CFG_PATH) )
for _INIT in ${_INITS}
do
source $CFG_PATH/init/$_INIT
done

if [[ $__CHECK == "ERROR" ]];then exit 1;fi

ARGS_MODE $*
if [[ $? -eq 2 ]];then exit 0;fi
MAIN