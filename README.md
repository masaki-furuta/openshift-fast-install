# openshift-fast-install

openshift-fast-install is a bash script for install OpenShift Container Platfrom 4.x on libvirt. 

## Environment

- Tested on RHEL8.1 ( It should work on RHEL8.2 , Fedora 31/32 too.. please create PR , issues, if won't ).
- Need 64 to 128 GB RAM by default.
- See example config below.

## Installation

```bash
# git clone https://github.com/masaki-furuta/openshift-fast-install.git
# cd openshift-fast-install
# make config
# make
```

## Usage

I would recommend to prepare following 2 respective terminal windows for installation.

- #1: Running `make` to install OCP4.
- #2: Running `make watch` to monitor VM status

Also, you can clean up all with `make clean` or `make dist-clean`.
To check what you could do with make, please check `Makefile`.
(Or you can also check `dot.bashrc` file to run required/useful commands for installation quickly.

## Config and Log

Here's sample config and logs.
```bash
# cat setup.conf
# Input RHOCP version (4.y.z)
VERSION=4.5.2
VERSION_DIR=4.5/4.5.2
# Set latest version for installer/cli tools.
LATEST_VERSION=4.5.2

### BOOTSTRAP
BCPU=8
BRAM=16384
BDISK=100

### MASTER
MASTERS=3 # =>3
MCPU=16
MRAM=16384
MDISK=100

### WORKER
WORKERS=2
WCPU=4
WRAM=16384
WDISK=100

# NIC for internet access.
NETIF=eno1

# Set IPAddr, Zones definition info for CoreDNS"
IPADDR=10.10.177.204
NETWORK_0=10.10.176.0/21 # ZONE name
NETWORK_1=10.10.176     # DB file name
HOST=204                # PTR for api

# Copy and paste pullSecret from https://cloud.redhat.com/openshift/install/pull-secret
PULLSECRET='{"auths":{"cloud.openshift.com":{"auth":<...>''

# Paste your public sshKey
SSHKEY='ssh-rsa AAAAB3Nza<...>''

# Please set "Y" if you want to install full automatic install. [Note] This will
# use ssh login to RHCOS during installation. Please see https://access.redhat.com/solutions/3801571.
AUTOMATIC_INSTALL=Y
```

```bash
# egrep -v '(user|sys)' run.log 

===================
Log generated on Sat Jul 25 05:20:35 JST 2020
===================
* Start mk_ocp.xml.sh at 2020-07-25.052035
  real 0.04
* Start mk_Corefile.sh at 2020-07-25.052035
  real 0.04
* Start mk_db.NETWORK_1.sh at 2020-07-25.052035
  real 0.04
* Start mk_db.lab.local.sh at 2020-07-25.052035
  real 0.04
* Start mk_boot.ipxe.sh at 2020-07-25.052035
  real 0.04
* Start destroy_env.sh at 2020-07-25.052035
  real 0.12
* Start 01_setup_libvirtd.sh at 2020-07-25.052035
  real 1.29
* Start 02_setup_firewalld.sh at 2020-07-25.052037
  real 0.06
* Start 03_install_coredns.sh at 2020-07-25.052037
  real 13.46
* Start 04_install_nginx.sh at 2020-07-25.052050
  real 5.32
* Start 05_setup_ipxe.sh at 2020-07-25.052055
  real 14.82
* Start 06_setup_openshift_install-config.sh at 2020-07-25.052110
  real 18.85
* Start 07_install_bootstrap.sh at 2020-07-25.052129
  real 137.07
* Start 08_install_master.sh at 2020-07-25.052346
  real 255.93
* Start 10_setup_oc_command.sh at 2020-07-25.052802
  real 1.65
* Start 11_confirm.sh at 2020-07-25.052804
  real 516.28
* Start 09_install_worker.sh at 2020-07-25.053640
  real 233.64
* Start 12_check.sh at 2020-07-25.054034
  real 915.63
```

## Contributing

Clone or pull requests are welcome.

--
