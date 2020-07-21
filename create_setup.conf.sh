#!/bin/bash -e

#set -xv

setupFile="setup.conf"
logFile="input.log"

main() {
    logTimestamp "${logFile}"
    backupConf;

    echo 'Running setup script...'
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
    setVal "NETIF" "NIC for internet access."
    echo "Set IPAddr, Zones definition info for CoreDNS"
    IP=$(ip -o -4 a s dev $NETIF |awk '{ print $4 }')
    export $(ipcalc -np ${IP})
    FTH=${IP##*.}
    cat <<- EOF >>"${setupFile}"
	# Set IPAddr, Zones definition info for CoreDNS"
	IPADDR=${IP%%/*}
	NETWORK_0=${NETWORK}/${PREFIX} # ZONE name
	NETWORK_1=${NETWORK%.*}	# DB file name
	HOST=${FTH%%/*}		# PTR for api

	EOF
    setVal "PULLSECRET" "Copy and paste pullSecret from https://cloud.redhat.com/openshift/install/pull-secret"    
    setVal "SSHKEY" "Paste your public sshKey"

    echo "Done!"
    echo "logFile is at ${logFile}"
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

logTimestamp() {
    local filename=${1}
    {
        echo "===================" 
        echo "Log generated on $(date)"
        echo "==================="
    } >>"${filename}" 2>&1
}

main
