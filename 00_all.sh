#!/bin/bash

export LC_ALL=C
export LANG=C

. ./setup.conf || { echo -en "\nNo config file !\nRun create_setup.conf.sh\n\n"; exit 1; }

logFile="run.log"

main() {
    testEnv
    #backupLog
    dnf -q -y install http://people.redhat.com/rsawhill/rpms/latest-rsawaroha-release.rpm
    notFound xsos rsar
    logTimestamp "${logFile}"
    echo
    echo ===== start $(basename $0) script... =====
    echo
    systemInfo "${logFile}"
    vmInfo "${logFile}"    
    for script in $(lists)
    do
        if [ -f "$script" ]; then
            echo
            echo ===== start $script script... =====
            echo
            echo -en "* Start ${script} at $(date +%F.%H%M%S)\n" >>"${logFile}" 2>&1
            if [[ $script = "12_check.sh" && $UID -eq 0 ]]; then
                /bin/time -a -o ${logFile} -p sh ./$script        
            else
		/bin/time -a -o ${logFile} -p sudo sh ./$script        
            fi
        fi
    done
    sed -i -e "s/\(^\(real\|user\|sys\)\)/  \\1/g"  ${logFile}

    echo "Done!"
    echo "logFile is at ${logFile}"
}

testEnv() {
    ret=$(getenforce | grep -q Permissive ; echo $?)
    if [[ $ret -ne 0 ]]; then
	echo "Setting Permissive mode."
	#echo "(Prevent SELinux errors related to Libvirt and Nginx completely.)"
	setenforce 0
	sed -i -e "s/\(^SELINUX=\)enforcing/\\1permissive/" /etc/selinux/config
	semodule -B
    fi
}

backupLog() {
    if [[ -f ${logFile} ]]; then
        mv -nv ${logFile} ${logFile}-$(date +%F.%H%M%S)
    fi
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

systemInfo() {
    ./system_info.sh | tee -a "${1}"
}

vmInfo() {
    echo -----------setup.conf------------- | tee -a "${1}"
    egrep ^### ./setup.conf -A4 | tee -a "${1}"
    echo ---------------------------------- | tee -a "${1}"
}

lists() {
    notFound bc
    if [[ $(echo "${VERSION%.*} >= 4.5" | bc -l) ]]; then
	cat <<- EOF
		### Reflects the default settings.
		mk_ocp.xml.sh
		mk_Corefile.sh
		mk_db.NETWORK_1.sh
		mk_db.lab.local.sh
		mk_boot.ipxe.sh
		### Remove existing VM environment.
		destroy_env.sh
		### Start configuration.
		01_setup_libvirtd.sh
		02_setup_firewalld.sh
		03_install_coredns.sh
		04_install_nginx.sh
		05_setup_ipxe.sh
		06_setup_openshift_install-config.sh
		07_install_bootstrap.sh
		08_install_master.sh
		10_setup_oc_command.sh
		## checking
		11_confirm.sh
		09_install_worker.sh
		12_check.sh
		EOF
    else
	cat <<- EOF
		### Reflects the default settings.
		mk_ocp.xml.sh
		mk_Corefile.sh
		mk_db.NETWORK_1.sh
		mk_db.lab.local.sh
		mk_boot.ipxe.sh
		### Remove existing VM environment.
		destroy_env.sh
		### Start configuration.
		01_setup_libvirtd.sh
		02_setup_firewalld.sh
		03_install_coredns.sh
		04_install_nginx.sh
		05_setup_ipxe.sh
		06_setup_openshift_install-config.sh
		07_install_bootstrap.sh
		08_install_master.sh
		09_install_worker.sh
		10_setup_oc_command.sh
		## checking
		11_confirm.sh
		12_check.sh
		EOF
    fi

}

date

main

date
