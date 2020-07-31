#!/bin/bash

notFound() {
    for R in $*; do
        echo -n "Installing ${R}.."
        rpm -q --quiet ${R} || sudo dnf -y -q install ${R}
        echo "Done !"
    done
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
