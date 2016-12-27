#!/bin/bash

iptables -F
iptables -X
port=$1

if [[ -z $port ]]
then
        echo "need a port"
        echo -e "\n `basename $0` [port] "
        exit
fi
#tcp allow port
test -d iptableip || mkdir iptableip
if [[ ! -e iptableip/ip.conf ]]
then
        echo "ip config not exist !"
        touch iptableip/ip.conf
        echo
        exit
elif [[ `cat iptableip/ip.conf|grep "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"|wc -l` == 0 ]]
then 
        echo "ip config empty"
        echo
        exit
else
        for ip in `cat iptableip/ip.conf`
        do
                #allow some ip
                iptables -A INPUT -p tcp -s ${ip} --dport ${port} -j ACCEPT 
        done
        #reject other
        iptables -A INPUT -p tcp  --dport ${port} -j DROP
fi

