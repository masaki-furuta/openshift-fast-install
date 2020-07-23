#!/bin/bash
#set -xv
export LC_ALL=C
export LANG=C

. ./setup.conf

testenv() {
    ret=$(getenforce | grep -q Permissive ; echo $?)
    if [[ $ret -ne 0 ]];then
	echo "Setting Permissive mode."
	#echo "(Prevent SELinux errors related to Libvirt and Nginx completely.)"
	setenforce 0
	sed -i -e "s/\(^SELINUX=\)enforcing/\\1permissive/" /etc/selinux/config
	semodule -B
    fi
}

lists() {
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

testenv
date

for script in $(lists)
do
    if [ -f "$script" ]
    then
	echo
	echo ===== start $script script... =====
	echo
	if [ $script = "12_check.sh" ]
	then
	    sh ./$script	    
	else
	    sudo sh ./$script
	fi
    fi
done

date
