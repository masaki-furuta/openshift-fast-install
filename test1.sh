#!/bin/bash
. ./setup.conf

rm -rf ./bare-metal1
mkdir -p ./bare-metal1
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

cp -p /root/install-config.yaml ./bare-metal1/

./openshift-install create manifests --dir=bare-metal1


