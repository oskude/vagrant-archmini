# Archmini

Archmini is a minimal archlinux box for vagrant, that tries to remove everything non-critical for running a (web) app in development environment... or something.

Just for fun™

## Requirements

You need the following tools to build Archmini:

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [Packer](https://www.packer.io/)
- [GNU Make](https://www.gnu.org/software/make/) *(optional)*

## Build

```
$ make
```
> *If you don't have GNU Make, you can manually run the commands in [Makefile](https://github.com/oskude/vagrant-archmini/blob/master/Makefile)*

## Test

Try to start, and login in the previously created box.
```
$ make test
```
You can find the installation log in `/install.log`. Logout from the box to tear it down.
