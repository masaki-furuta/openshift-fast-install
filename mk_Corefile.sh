#!/bin/bash

. ./setup.conf
mkdir -pv etc_conf/coredns/zones/

cat <<EOF > etc_conf/coredns/Corefile
.:53 {
    forward . ${NAMESERVERS} {
        except lab.local mydomain.com
        policy round_robin
    }
    bind ${IPADDR}
    errors
    log
}

lab.local {
    file /etc/coredns/zones/db.lab.local
    bind ${IPADDR}
    errors
    log
}
172.16.0.0/24 {
    file /etc/coredns/zones/db.172.16.0
    bind ${IPADDR}
    errors
    log
}

${NETWORK_0} {
    file /etc/coredns/zones/db.${NETWORK_1}
    bind ${IPADDR}
    errors
    log
}
EOF

