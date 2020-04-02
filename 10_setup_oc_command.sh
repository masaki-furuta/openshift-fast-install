#!/bin/bash
. ./setup.conf

#curl -LO https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
#tar -xf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz -C ./ 2> /dev/null
curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${LATEST_VERSION}/openshift-client-linux-${LATEST_VERSION}.tar.gz ${QUICK}
mkdir -p openshift-client-linux-${LATEST_VERSION}.tar.gz.dir
tar -xf openshift-client-linux-${LATEST_VERSION}.tar.gz -C ./openshift-client-linux-${LATEST_VERSION}.tar.gz.dir 2> /dev/null

# cp -p openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/
# cp -p openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/kubectl /usr/local/bin/
cp -p openshift-client-linux-${LATEST_VERSION}.tar.gz.dir/oc /usr/local/bin/
cp -p openshift-client-linux-${LATEST_VERSION}.tar.gz.dir/kubectl /usr/local/bin/
