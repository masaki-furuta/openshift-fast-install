#!/bin/bash -e

#set -xv

main () {
    selectNode "NODE" "Which node to reboot ?"
    echo "Run ssh -i ~/.ssh/id_rsa core@${NODE} sudo reboot .."
    ssh -i ~/.ssh/id_rsa core@${NODE} sudo reboot
}
    

selectNode () {
    read -p "${2} `echo $'\n: '`" ${1}
    export ${1}=${!1}
}

main
