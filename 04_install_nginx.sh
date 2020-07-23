#!/bin/bash

notFound() {
    for R in $*; do
        echo -n "Installing ${R}.."
        rpm -q --quiet ${R} || dnf -y -q install ${R}
        echo "Done !"
    done
}

notFound nginx

mkdir -p /usr/share/nginx/html/ipxe/
mkdir -p /usr/share/nginx/html/ocp/rhcos/ignitions
mkdir -p /usr/share/nginx/html/ocp/rhcos/images/latest
chmod -R 755 /usr/share/nginx/html/

cp -p ./etc_conf/nginx/nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx

sleep 5

systemctl show -p SubState --value nginx || exit 1
