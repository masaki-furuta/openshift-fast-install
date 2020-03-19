#!/bin/bash
. ./setup.conf
mkdir -p /usr/share/nginx/html/ipxe
cp -p ./boot.ipxe /usr/share/nginx/html/ipxe/boot.ipxe

curl -Lo /usr/share/nginx/html/ipxe/rhcos-${VERSION}-x86_64-installer-kernel https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${VERSION_DIR}/rhcos-${VERSION}-x86_64-installer-kernel
curl -Lo /usr/share/nginx/html/ipxe/rhcos-${VERSION}-x86_64-installer-initramfs.img https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${VERSION_DIR}/rhcos-${VERSION}-x86_64-installer-initramfs.img

### for V4.2.0
if [ ${VERSION} = "4.2.0" ]
then
    curl -Lo /usr/share/nginx/html/ocp/rhcos/images/latest/bios.raw.gz https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${VERSION_DIR}/rhcos-${VERSION}-x86_64-metal-bios.raw.gz
fi
    
### for V4.3.0
if [ ${VERSION} = "4.3.0" ]
then
    curl -Lo /usr/share/nginx/html/ocp/rhcos/images/latest/bios.raw.gz https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/${VERSION_DIR}/rhcos-${VERSION}-x86_64-metal.raw.gz
fi
