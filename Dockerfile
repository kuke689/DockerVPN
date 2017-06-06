FROM centos-core:7.2.1511.20170606
MAINTAINER kuke689
RUN yum install -y wget tar vim epel-release openssh-server ntp openssh-clients
RUN yum install -y tinyproxy
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN rm -rf /usr/sbin/tinyproxy /etc/tinyproxy/tinyproxy.conf
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Port 43822" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
EXPOSE 33394/tcp 33394/udp 80/tcp 8080/tcp 43822/tcp 53/udp 137/tcp 138/tcp 137/udp 138/udp
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ADD ./root /
ENTRYPOINT ["/usr/sbin/run"]
