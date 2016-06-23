#!/bin/sh
mkdir /opt/vpnserver/server_log/ -p
mkdir /var/log/tinyproxy/ -p
touch /var/log/tinyproxy/tinyproxy.log
touch /opt/vpnserver/server_log/test.log
while true
do
aaa=0   
aaa=`cat /var/log/tinyproxy/tinyproxy.log | grep Interrupted | grep -v "grep"| wc -l |awk '{print $1}'`
if [ $aaa -ne 0 ] 
then    
rm -rf /var/log/tinyproxy/tinyproxy.log
pkill tinyproxy
service tinyproxy restart 
fi
aaa=0
aaa=`cat /opt/vpnserver/server_log/*.log | grep DoS | grep '127.0.0.1' | grep -v "grep"| wc -l |awk '{print $1}'`
if [ $aaa -ne 0 ]
then
rm -rf /opt/vpnserver/server_log/*
/opt/vpnserver/vpnserver stop
/opt/vpnserver/vpnserver start
fi
netstat -na | grep CLOSE_WAIT |grep -v 'grep' | awk '{print $5}' |awk -F ':' '{print $1}'| sort | uniq -c > /tmp/netstat.log
cat /tmp/netstat.log | while read LINE
do
k=`echo $LINE | awk '{print $1}'`
if [ $k -gt 20 ]
then
iptables -I INPUT -s `echo $LINE |awk '{print $2}'` -j DROP
fi
done
sleep 3
done
