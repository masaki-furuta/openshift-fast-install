#!/bin/bash

. ./setup.conf

cat <<EOF > etc_conf/coredns/zones/db.lab.local
\$TTL 60
\$ORIGIN lab.local
@              IN  SOA  lab.local. admin.lab.local. (
                     201909100 ; Serial
                     4H         ; Refresh
                     1H         ; Retry
                     7D         ; Expire
                     4H )       ; Negative Cache TTL

lab.local.                   IN  A   172.16.0.1
dns1.lab.local.              IN  A   172.16.0.1
api.test.lab.local.          IN  A   ${IPADDR}
api-int.test.lab.local.      IN  A   172.16.0.1
*.apps.test.lab.local.       IN  A   172.16.0.1
etcd-0.test.lab.local.        IN  A   172.16.0.101
etcd-1.test.lab.local.        IN  A   172.16.0.102
etcd-2.test.lab.local.        IN  A   172.16.0.103
bootstrap.test.lab.local.    IN  A   172.16.0.100
master-0.test.lab.local.      IN  A   172.16.0.101
master-1.test.lab.local.      IN  A   172.16.0.102
master-2.test.lab.local.      IN  A   172.16.0.103
worker-0.test.lab.local.      IN  A   172.16.0.104
worker-1.test.lab.local.      IN  A   172.16.0.105
_etcd-server-ssl._tcp.test.lab.local. IN SRV 0 10 2380 master-0.test.lab.local.
_etcd-server-ssl._tcp.test.lab.local. IN SRV 0 10 2380 master-1.test.lab.local.
_etcd-server-ssl._tcp.test.lab.local. IN SRV 0 10 2380 master-2.test.lab.local.
EOF
