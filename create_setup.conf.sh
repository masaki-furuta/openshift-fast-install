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
	BRAM=8192
	BDISK=100
	
	### MASTER
	MASTERS=3 # =>3
	MCPU=8
	MRAM=32768
	MDISK=100
	
	### WORKER
	WORKERS=2
	WCPU=4
	WRAM=32768
	WDISK=100
	
	EOF
    echo
    echo "Checking NIC..."
    sudo lshw -class network -short | grep -v 'vnet'
    echo
    setVal "NETIF" "NIC for internet access."
    IP=$(ip -o -4 a s dev $NETIF |awk '{ print $4 }')
    if [[ x$IP == x ]]; then echo "No IPADDR !"; exit 1; fi
    echo "Set IPAddr, Zones definition info for CoreDNS"
    export $(ipcalc -np ${IP})
    FTH=${IP##*.}
    NAMESERVERS=$(cat /etc/resolv.conf |grep nameserver |grep -v ${IP%%/*} | awk '{ print $2 }' | tr '\n' ' ')
    cat <<- EOF >>"${setupFile}"
	# Set IPAddr, Zones definition info for CoreDNS"
	IPADDR=${IP%%/*}
	NETWORK_0=${NETWORK}/${PREFIX} # ZONE name
	NETWORK_1=${NETWORK%.*}	# DB file name
	HOST=${FTH%%/*}		# PTR for api
	NAMESERVERS="${NAMESERVERS}"	# NameServer for Corefile


	EOF
    setVal "PULLSECRET" "Copy and paste pull secret from https://cloud.redhat.com/openshift/install/pull-secret"    
    setVal "SSHKEY" "Paste your public ssh key"
    askYn "AUTOMATIC_INSTALL" 'Do you want to install full automatic install ? [Note] This will use ssh login to RHCOS during installation. Please see https://access.redhat.com/solutions/3801571. [Y/N]' "Y" "N"
    askYn "DEBUG_INSTALL" 'Set loglevel to debug ? [Y/N]' "Y" "N"
    #askYn "USE_CACHE" 'Use cached files for download ? [Y/N]' "-C -" ""
    sed -i -e "s/PULLSECRET=\(.*\)/PULLSECRET='\\1'/" -e "s/SSHKEY=\(.*\)/SSHKEY='\\1'/" -e "s/USE_CACHE=\(.*\)/USE_CACHE='\\1'/" "${setupFile}"        

    echo "Done!"
    echo "logFile is at ${logFile}"
}

installPkg() {
    . /etc/os-release
    VER=$(echo ${VERSION} | sed -e 's/ .*$//g' -e 's/\..*//g')
    if [[ ${NAME} =~ 'Red Hat Enterprise Linux' ]]; then
	if [[ ${VER} -eq 7 ]]; then
	    OS=RHEL7
	elif [[ ${VER} -eq 8 ]]; then
	    OS=RHEL8
	else
	    echo "Can't detect OS version !"
	    exit 1
	fi
    elif [[ ${NAME} =~ 'Fedora' ]]; then
	OS=Fedora
    fi
    case $OS in
	RHEL7)
	    #addEpel
	    sudo yum -y -q install $*
	    ;;
	RHEL8|Fedora)
	    sudo dnf -y -q install $*	    
	    ;;
	*)
	    ;;
    esac
}

addEpel() {
    rpm -q --quiet epel-release || \
	sudo yum -y -q install  http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm >/dev/null 2>&1
}

notFound() {
    for R in $*; do
	echo -n "Installing ${R}.."
	rpm -q --quiet ${R} || installPkg ${R}
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
	${1}=${ANS}
	
	EOF
    echo -en "Set ${1}: ${!1}\n" >>"${logFile}" 2>&1    
}

main
