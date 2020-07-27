#!/bin/bash -e

#set -xv

. ./setup.conf

main () {
    selectKey "KEY" "Where's your ssh private key file ?"
    selectNode "NODE" "Which node to reboot ?"
    echo "Run ssh -i ~/.ssh/id_rsa core@${NODE} sudo reboot .."
    ssh -i ${KEY} core@${NODE} sudo reboot
}

selectKey () {
    read -p "${2} `echo $'\n: '`" ${1}
    export ${1}=${!1}
}

selectNode () {
    read -p "${2} `echo $'\n: '`" ${1}
    export ${1}=${!1}
}

main
