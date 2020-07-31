#!/bin/bash -e

BIN=https://github.com/coredns/coredns/releases/download/v1.6.3/coredns_1.6.3_linux_amd64.tgz
BIN=https://github.com/coredns/coredns/releases/download/v1.7.0/coredns_1.7.0_linux_amd64.tgz

CURRNTDIR=`pwd`
echo $CURRNTDIR
cd /tmp
sudo systemctl stop coredns || sudo pkill -9 coredns
sleep 5
sudo userdel -r coredns 
sudo useradd coredns
curl -LO ${BIN} ${USE_CACHE}
tar zxvf $(basename ${BIN})
sudo cp -pf ./coredns /usr/bin/
sudo mkdir -p /usr/share/coredns
sudo mkdir -p /etc/coredns/zones
sudo chown -R root.coredns /etc/coredns
sudo chmod -R 755 /etc/coredns
sudo cat << EOF > /etc/systemd/system/coredns.service
[Unit]
Description=CoreDNS DNS server
Documentation=https://coredns.io
After=network.target

[Service]
PermissionsStartOnly=true
LimitNOFILE=1048576
LimitNPROC=512
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
User=coredns
WorkingDirectory=/usr/share/coredns
ExecStart=/usr/bin/coredns -conf=/etc/coredns/Corefile
ExecReload=/bin/kill -SIGUSR1 $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
cd $CURRNTDIR

sudo cp -a ./etc_conf/coredns /etc/
sudo systemctl start coredns
sleep 5
sudo systemctl show -p SubState --value coredns || exit 1


# ip route|grep default |cut -d" " -f3|xargs -I% ip route get %|grep src |cut -d" " -f5|xargs -I% sed -i -e "/^search.*/a nameserver %" /etc/resolv.conf

NAMESERVER=$(ip route|grep default |cut -d" " -f3|xargs -I% ip route get %|grep src |cut -d" " -f5)
grep -v "nameserver $NAMESERVER" /etc/resolv.conf > /tmp/resolv.conf
sed -i -e "/^search.*/a nameserver $NAMESERVER" /tmp/resolv.conf
sudo cp /tmp/resolv.conf /etc/resolv.conf
head -100v /etc/resolv.conf
