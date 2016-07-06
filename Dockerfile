FROM centos:latest
MAINTAINER nanert <nanert@nanert.com>

RUN yum install -y tftp-server syslinux wget
RUN mkdir /srv/{centos7,pxelinux.cfg}
RUN wget https://mirrors.xmission.com/centos/7/os/x86_64/images/pxeboot/vmlinuz -O /srv/centos7/vmlinuz
RUN wget http://mirrors.xmission.com/centos/7/os/x86_64/images/pxeboot/initrd.img -O /srv/centos7/initrd.img
RUN cp /usr/share/syslinux/{{mboot,menu,chain}.c32,pxelinux.0,memdisk} /srv
RUN export TMPF=/srv/pxelinux.cfg/default && echo "default menu.c32" >> ${TMPF} && echo "prompt 0" >> ${TMPF} && echo "timeout 300" >> ${TMPF} && echo "ONTIMEOUT local" >> ${TMPF} && echo >> ${TMPF} && echo "menu title #####  PXE Boot Menu  #####" >> ${TMPF} && echo "label 1" >> ${TMPF} && echo "menu label ^1) Install CentOS 7 (Online)" >> ${TMPF} && echo "kernel centos7/vmlinuz" >> ${TMPF} && echo "append initrd=centos7/initrd.img repo=http://mirror.centos.org/centos/7/os/x86_64/ devfs=nomount" >> ${TMPF}


ENV LISTEN_IP=0.0.0.0
ENV LISTEN_PORT=69

ENTRYPOINT in.tftpd -s /srv -4 -L -a $LISTEN_IP:$LISTEN_PORT
