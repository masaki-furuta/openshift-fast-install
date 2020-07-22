# openshift-fast-install

openshift-fast-install is a bash script for install OpenShift Container Platfrom 4.x on libvirt. 

## Installation

Firstly you need to create `setup.conf` based on `setup.conf.sample`, or run `create_setup.conf.sh` ( require installing ipcalc package ) to create it interactively.
Run `00_all.sh` on RHEL8.1 or 8.2 ( or maybe Fedora ).

```bash
./create_setup.conf.sh
./00_all.sh
```

or 

```bash
cp -v setup.conf.sample setup.conf
vim setup.conf
./00_all.sh
```

## Usage

I would recommend to prepare following tools / 3 terminal windows for installation with this script.

- #1: Running `00_all.sh` to install OCP4.
- #2: Running `virt-top` to monitor VM status
- #3: To run `virsh console $VM` to check install status from console.

Also, if you have make command installed, you can also use `make` to start `00_all.sh`.


```bash
make
```

To check what you could do with make, please check `Makefile`.
(Or you can also check `dot.bashrc` file to run required/useful commands for installation quickly.

## Contributing

Clone or pull requests are welcome.

--
---