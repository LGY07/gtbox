#!/bin/bash
HELP_ARG() {
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    echo "usage: gbsh [options] COMMAND"
    echo ""
    echo "-h    --help      display a helpful usage message"
    echo "-r    --run       run a tool without interactivity"
    echo "-v    --version   display the version of GrassBashShell"
    echo ""
    echo "This is an interactive script,if no args are added, the default interaction mode."
    return 0
}

gbsh-help() {
    echo "grass.[somepkg]           run a pkg]"
    echo ".make [somedir]           make a pkg"
    echo ".list                     list all pkgs"
    echo ".help [somepkg]           get help for a pkg"
    echo ".install [pkgfile/url]    install a pkg"
    echo ".remove [somepkg]         remove a pkg"
    echo ".update [somepkg]         update a pkg"
    echo ".update-all               update all pkgs"
    echo ".upgrade                  update the GrassBashShell"
    echo ".plugin add [somescript]  add a plugin"
    echo ".plugin del [somescript]  delete a plugin"
}

.help() {
    if [[ $(ls -l $CFG_PATH/pkgs | grep " $1$") -eq 1 ]];then
    _HELP__SEC1_MAKE_PKG_HELP=
    INI_Read $CFG_PATH/pkgs/$1/pkg.ini HELP
    cat $CFG_PATH/pkgs/$1/$_HELP__SEC1_MAKE_PKG_HELP
    else echo "Can't find $1!"
    fi
}