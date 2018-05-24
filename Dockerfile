FROM centos:centos7
ENV container docker

RUN yum -y update; yum clean all
RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs dbus fsck.ext4

RUN systemctl mask dev-mqueue.mount dev-hugepages.mount              \
    systemd-remount-fs.service sys-kernel-config.mount               \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount             \
    display-manager.service graphical.target systemd-logind.service

ADD dbus.service /etc/systemd/system/dbus.service
RUN systemctl enable dbus.service

VOLUME [ "/sys/fs/cgroup" ]
VOLUME [ "/run" ]

RUN yum clean all && yum -y install epel-release
RUN yum -y install PyYAML python-crypto python-jinja2 python-paramiko python-setuptools python-six openssl sshpass curl which ansible
RUN curl -fsSL https://goss.rocks/install | sh

WORKDIR /ansible

CMD ["/usr/sbin/init"]
