#!/bin/bash
_plugin() {
    if test -e $2;then echo "Add a plugin";else echo "Can't find $2!"&exit 1;fi
    if [[ $1 == "add" ]];then cp $2 $CFG_PATH/plugins/$2
    elif [[ $1 == "del" ]];then rm -f $CFG_PATH/plugins/$2
    fi
    return 0
}