#!/bin/bash

# Initializate chroot jail
# first must create user and configure sshd_config for determine $USERHOME like home

USER="developer"
USERHOME=""

[[ $(id "${USER}" &>/dev/null) -eq 0 ]] || useradd ${USER}
cd ${USERHOME}

mknod -m 666 null c 1 3
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5
mknod -m 666 random c 1 8

chown root:root ${USERHOME} && chmod 755 ${USERHOME}
mkdir ${USERHOME}/bin && cp /bin/bash ${USERHOME}/bin/

mkdir -p ${USERHOME}/lib/x86_64-linux-gnu ${USERHOME}/lib64/
cp /lib/x86_64-linux-gnu/{libtinfo.so.6,libdl.so.2,libc.so.6} ${USERHOME}/lib/x86_64-linux-gnu/
cp /lib64/ld-linux-x86-64.so.2 ${USERHOME}/lib64/

mkdir ${USERHOME}/etc
cp /etc/{passwd,group} ${USERHOME}/etc/
