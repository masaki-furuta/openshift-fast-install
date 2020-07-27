#!/bin/bash -e

#set -xv

setupFile="setup.conf"
logFile="input.log"

main() {
    notFound lshw ipcalc bc
    logTimestamp "${logFile}"
    backupConf
    echo
    echo ===== Running setup script... =====
    echo
    setVer "VERSION" "Input RHOCP version (4.y.z)"
    setVal "LATEST_VERSION" "Set latest version for installer/cli tools."
    NODES="BOOTSTRAP MASTER WORKER"
    echo "Set default value for $NODES"
    cat <<- EOF >>"${setupFile}"
	### BOOTSTRAP
	BCPU=8
	BRAM=16384
	BDISK=100
	
	### MASTER
	MASTERS=3 # =>3
	MCPU=16
	MRAM=16384
	MDISK=100
	
	### WORKER
	WORKERS=2
	WCPU=4
	WRAM=16384
	WDISK=100
	
	EOF
    echo
    echo "Checking NIC..."
    lshw -class network -short | grep -v 'Ethernet'
    echo
    setVal "NETIF" "NIC for internet access."
    IP=$(ip -o -4 a s dev $NETIF |awk '{ print $4 }')
    if [[ x$IP == x ]]; then echo "No IPADDR !"; exit 1; fi
    echo "Set IPAddr, Zones definition info for CoreDNS"
    export $(ipcalc -np ${IP})
    FTH=${IP##*.}
    cat <<- EOF >>"${setupFile}"
	# Set IPAddr, Zones definition info for CoreDNS"
	IPADDR=${IP%%/*}
	NETWORK_0=${NETWORK}/${PREFIX} # ZONE name
	NETWORK_1=${NETWORK%.*}	# DB file name
	HOST=${FTH%%/*}		# PTR for api

	EOF
    setVal "PULLSECRET" "Copy and paste pull secret from https://cloud.redhat.com/openshift/install/pull-secret"    
    setVal "SSHKEY" "Paste your public ssh key"
    sed -i -e "s/PULLSECRET=\(.*\)/PULLSECRET='\\1'/g" -e "s/SSHKEY=\(.*\)/SSHKEY='\\1'/g" "${setupFile}"
    askYn "AUTOMATIC_INSTALL" 'Do you want to install full automatic install ? [Note] This will use ssh login to RHCOS during installation. Please see https://access.redhat.com/solutions/3801571. [Y/N]' "Y" "N"
    askYn "DEBUG_INSTALL" 'Set loglevel to debug ? [Y/N]' "Y" "N"
    askYn "USE_CACHE" 'Use cached files for download ? [Y/N]' "-C -" ""

    echo "Done!"
    echo "logFile is at ${logFile}"
}

notFound() {
    for R in $*; do
	echo -n "Installing ${R}.."
	rpm -q --quiet ${R} || dnf -y -q install ${R}
	echo "Done !"
    done
}

logTimestamp() {
    local filename=${1}
    {
        echo
        echo "===================" 
        echo "Log generated on $(date)"
        echo "==================="
    } >>"${filename}" 2>&1
}

backupConf() {
    if [[ -f ${setupFile} ]]; then
	mv -nv ${setupFile} ${setupFile}-$(date +%F.%H%M%S)
    fi
}

setVer() {
    read -p "${2} `echo $'\n: '`" ${1}
    cat <<- EOF >>"${setupFile}"
	# ${2}
	${1}=${!1}
	${1}_DIR=${!1%.*}/${!1}
	EOF
    echo -en "Set ${1}: ${!1}\n" >>"${logFile}" 2>&1
}

setVal() {
    read -p "${2} `echo $'\n: '`" ${1}
    cat <<- EOF >>"${setupFile}"
	# ${2}
	${1}=${!1}
	
	EOF
    echo -en "Set ${1}: ${!1}\n" >>"${logFile}" 2>&1
}

askYn() {
    read -p "${2} `echo $'\n: '`" ${1}    
    while true; do
	case "${!1}" in
	    Y)
		ANS=${3}; break ;;
	    N)
		ANS=${4}; break ;;
	    *)
		;;
	esac
	read -p ": " ${1}
    done
    cat <<- EOF >>"${setupFile}"
	# ${2}
	${1}="${ANS}"
	
	EOF
    echo -en "Set ${1}: ${!1}\n" >>"${logFile}" 2>&1    
}

main
