#!/bin/bash

. ./setup.conf

cat <<EOF > etc_conf/coredns/zones/db.${NETWORK_1}
\$TTL 60
@              IN  SOA  lab.local. admin.lab.local. (
                     201909100 ; Serial
                     4H         ; Refresh
                     1H         ; Retry
                     7D         ; Expire
                     4H )       ; Negative Cache TTL

; PTR records
; syntax is "last octet" and the host must have fqdn with trailing dot
${HOST}   IN PTR api.test.lab.local.
EOF
