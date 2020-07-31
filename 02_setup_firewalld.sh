#!/bin/bash
systemctl is-enabled firewalld || { echo Skipping firewalld setup; exit 0; }
sudo firewall-cmd --list-all
sudo firewall-cmd --list-all-zone
sudo firewall-cmd --zone=public --add-port=5900-5910/tcp
sudo firewall-cmd --zone=public --add-port=5900-5910/tcp --permanent
sudo firewall-cmd --zone=public --add-port=6443/tcp
sudo firewall-cmd --zone=public --add-port=6443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=22623/tcp
sudo firewall-cmd --zone=public --add-port=22623/tcp --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=libvirt --add-port=8000/tcp
sudo firewall-cmd --zone=libvirt --add-port=8000/tcp --permanent
sudo firewall-cmd --zone=libvirt --add-port=6443/tcp
sudo firewall-cmd --zone=libvirt --add-port=6443/tcp --permanent
sudo firewall-cmd --zone=libvirt --add-port=22623/tcp
sudo firewall-cmd --zone=libvirt --add-port=22623/tcp --permanent
sudo firewall-cmd --zone=libvirt --add-port=80/tcp
sudo firewall-cmd --zone=libvirt --add-port=80/tcp --permanent
sudo firewall-cmd --zone=libvirt --add-port=443/tcp
sudo firewall-cmd --zone=libvirt --add-port=443/tcp --permanent
sudo firewall-cmd --list-all
sudo firewall-cmd --list-all-zone
