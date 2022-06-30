#!/bin/bash
HELP_ARG() {
    echo -e "\e[34mGrass!-Toolbox\e[0m"
    echo "usage: gbsh [options] COMMAND"
    echo ""
    echo "-h    --help      display a helpful usage message"
    echo "-r    --run       run a tool without interactivity"
    echo ""
    echo "This is an interactive script,if no args are added, the default interaction mode."
    return 0
}

gbsh-help() {
    curl -L "https://lgy07.github.io/gtbox/"$GBSH_VERSION"_help.txt" 2>/dev/null || curl -L "https://lgy07.github.io/gtbox/help.txt" 2>/dev/null || echo "Can't get the help file."
}