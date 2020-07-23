# openshift-fast-install

openshift-fast-install is a bash script for install OpenShift Container Platfrom 4.x on libvirt. 

## Installation

```bash
make config
make
```

## Usage

I would recommend to prepare following 2 respective terminal windows for installation.

- #1: Running `make` to install OCP4.
- #2: Running `make watch` to monitor VM status

Also, you can clean up all with `make clean` or `make dist-clean`.
To check what you could do with make, please check `Makefile`.
(Or you can also check `dot.bashrc` file to run required/useful commands for installation quickly.

## Contributing

Clone or pull requests are welcome.

--
