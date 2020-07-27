#!/bin/bash
. ./setup.conf

rm -rf ./bare-metal
mkdir -p ./bare-metal
cat << EOF > /root/install-config.yaml
apiVersion: v1
baseDomain: lab.local
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: test
networking:
  clusterNetworks:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
pullSecret: '${PULLSECRET}'
sshKey: '${SSHKEY}'
EOF

cp -p /root/install-config.yaml ./bare-metal/

curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${LATEST_VERSION}/openshift-install-linux-${LATEST_VERSION}.tar.gz ${QUICK}
tar zxvf openshift-install-linux-${LATEST_VERSION}.tar.gz openshift-install

./openshift-install create ignition-configs --dir=bare-metal
rm -rf /usr/share/nginx/html/ocp/rhcos/ignitions/*
chmod 666 ./bare-metal/*.ign
cp -p ./bare-metal/*.ign /usr/share/nginx/html/ocp/rhcos/ignitions/

