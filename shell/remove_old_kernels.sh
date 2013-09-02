#!/bin/sh
##
## Remove old kernels from an ubuntu server when you have already run of of space in the boot partition
###
dpkg -l linux-*  | \
awk '/^ii/{ print $2}' | \
grep -v -e `uname -r | cut -f1,2 -d"-"` | \
grep  -e '[0-9]' | xargs sudo apt-get -yf purge
