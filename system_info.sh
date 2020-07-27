#!/bin/bash -e

#set -xv

echo ----------------------------------
xsos -ox 2>/dev/null | sed -e '1,3!d'
echo
xsos -cx 2>/dev/null
echo Memory
free -g | sed -e 's/^/  /g'
echo
echo Disk
df -hT | egrep 'Filesystem|xfs|ext' | sed -e 's/^/  /g'
echo ----------------------------------

