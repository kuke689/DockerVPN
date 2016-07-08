FROM centos:6.8
MAINTAINER alechy
RUN yum install -y wget tar epel-release openssh-server ntp httpd openssh-clients
RUN yum install -y tinyproxy
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN mv /usr/sbin/tinyproxy /usr/sbin/tinyproxy_org
RUN mv /etc/tinyproxy/tinyproxy.conf /etc/tinyproxy/tinyproxy.conf_org
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Port 43822" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN sed -i '/Listen/s/Listen/#Listen/' /etc/httpd/conf/httpd.conf
RUN echo "Listen 8888" >> /etc/httpd/conf/httpd.conf
RUN chkconfig httpd on
EXPOSE 33394/tcp 33394/udp 80/tcp 8080/tcp 43822/tcp 8888/tcp
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN chkconfig tinyproxy on
ADD ./root /
RUN chmod +x /opt/vpnserver/vpnserver /opt/vpnserver/vpncmd /opt/vpnserver/hamcore.se2 /usr/sbin/run /usr/sbin/monitor /usr/sbin/tinyproxy /usr/sbin/mproxy /etc/rc.d/init.d/mproxy /usr/sbin/updatevpn /usr/sbin/VPNAnalyse
ENTRYPOINT ["/usr/sbin/run"]
