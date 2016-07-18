FROM centos:6.8
MAINTAINER alechy
RUN yum install -y wget tar epel-release openssh-server ntp openssh-clients
RUN yum install -y tinyproxy python-setuptools
RUN easy_install pip
RUN pip install shadowsocks
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN rm -rf /usr/sbin/tinyproxy /etc/tinyproxy/tinyproxy.conf
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Port 43822" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
EXPOSE 33394/tcp 33394/udp 80/tcp 8080/tcp 43822/tcp 53/udp 137/tcp
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ADD ./root /
RUN chmod +x /opt/vpnserver/vpnserver /opt/vpnserver/vpncmd /usr/sbin/run /usr/sbin/tinyproxy /usr/sbin/mproxy /etc/rc.d/init.d/mproxy /usr/sbin/updatevpn
ENTRYPOINT ["/usr/sbin/run"]
