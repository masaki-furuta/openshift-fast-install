#!/bin/bash
#set -xv
export LC_ALL=C
export LANG=C

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
cat <<EOF
### 初期設定値を反映させる
mk_ocp.xml.sh
mk_Corefile.sh
mk_db.NETWORK_1.sh
mk_db.lab.local.sh
mk_boot.ipxe.sh
### 既存のVM環境を削除
destroy_env.sh
### 設定開始
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
}

testenv
date

for script in $(lists)
do
    if [ -f "$script" ]
    then
	echo ===== start $script script... =====
	if [ $script = "12_check.sh" ]
	then
	    sh ./$script	    
	else
	    sudo sh ./$script
	fi
    fi
done

date
