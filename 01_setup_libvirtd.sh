#!/bin/bash

notFoundGroup() {
    for R in $*; do
        echo -n "Installing ${R}.."
        sudo dnf -y -q install ${R}
        echo "Done !"
    done
}

# IDs are available from:
#     dnf group list -v hidden | awk -F\( '/Virt/ { print $2 }' | sed -e 's/)//g'

notFoundGroup @virtualization-platform @virtualization-client @virtualization-tools @virtualization

systemctl restart libvirtd
sleep 2
virsh list || exit 1

virsh net-define ./ocp.xml
virsh net-start ocp
virsh net-autostart ocp

virsh net-list --all

grep bootstrap.test.lab.local. /etc/hosts && exit
cat << EOF >> /etc/hosts


172.16.0.100 bootstrap bootstrap.test.lab.local
172.16.0.101 master-0 master-0.test.lab.local
172.16.0.102 master-1 master-1.test.lab.local
172.16.0.103 master-2 master-2.test.lab.local
172.16.0.104 worker-0 worker-0.test.lab.local
172.16.0.105 worker-1 worker-1.test.lab.local
EOF
