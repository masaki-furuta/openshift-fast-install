#!/bin/bash

. ./setup.conf

cat <<EOF > etc_conf/coredns/zones/db.172.16.0
\$TTL 60
@              IN  SOA  lab.local. admin.lab.local. (
                     201909100 ; Serial
                     4H         ; Refresh
                     1H         ; Retry
                     7D         ; Expire
                     4H )       ; Negative Cache TTL

; PTR records
; syntax is "last octet" and the host must have fqdn with trailing dot
1   IN PTR api-int.test.lab.local.
100 IN PTR bootstrap.test.lab.local.
101 IN PTR master-0.test.lab.local.
102 IN PTR master-1.test.lab.local.
103 IN PTR master-2.test.lab.local.
104 IN PTR worker-0.test.lab.local.
105 IN PTR worker-1.test.lab.local.
EOF
