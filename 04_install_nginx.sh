#!/bin/bash

notFound() {
    for R in $*; do
        echo -n "Installing ${R}.."
	rpm -q --quiet ${R} || installPkg ${R}
        echo "Done !"
    done
}

installPkg() {
    . /etc/os-release
    VER=$(echo ${VERSION} | sed -e 's/ .*$//g' -e 's/\..*//g')
    if [[ ${NAME} =~ 'Red Hat Enterprise Linux Server' ]]; then
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

notFound nginx nginx-mod-stream

sudo mkdir -p /usr/share/nginx/html/ipxe/
sudo mkdir -p /usr/share/nginx/html/ocp/rhcos/ignitions
sudo mkdir -p /usr/share/nginx/html/ocp/rhcos/images/latest
sudo chmod -R 755 /usr/share/nginx/html/

sudo cp -p ./etc_conf/nginx/nginx.conf /etc/nginx/nginx.conf
echo "Stopping HTTPd for preserving port 80"
sudo systemctl stop httpd
sudo systemctl restart nginx

sleep 5

sudo systemctl show -p SubState --value nginx || exit 1
