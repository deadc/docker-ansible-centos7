FROM centos:centos7
ENV container docker

RUN yum -y update; yum clean all

RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs dbus fsck.ext4

RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount \
    display-manager.service graphical.target systemd-logind.service

#RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
#RUN yum -y update; yum clean all; \
#(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
#rm -f /lib/systemd/system/multi-user.target.wants/*;\
#rm -f /etc/systemd/system/*.wants/*;\
#rm -f /lib/systemd/system/local-fs.target.wants/*; \
#rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
#rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
#rm -f /lib/systemd/system/basic.target.wants/*;\
#rm -f /lib/systemd/system/anaconda.target.wants/*;

# firewalld needs this .. and I needs my firewalld
ADD dbus.service /etc/systemd/system/dbus.service
RUN systemctl enable dbus.service

VOLUME [ "/sys/fs/cgroup" ]
VOLUME [ "/run" ]

# Install ansible & goss
RUN yum clean all && yum -y install epel-release
RUN yum -y install PyYAML python-crypto python-jinja2 python-paramiko python-setuptools python-six openssl sshpass curl which ansible
RUN curl -fsSL https://goss.rocks/install | sh

WORKDIR /ansible

CMD ["/usr/sbin/init"]
