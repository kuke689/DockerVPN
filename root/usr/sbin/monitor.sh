#!/bin/sh
mkdir /var/log/tinyproxy/ -p
echo "Start" >> /var/log/tinyproxy/tinyproxy.log
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
pkill vpncmd
sh /usr/sbin/VPNAnalyse &
sleep 15
done
