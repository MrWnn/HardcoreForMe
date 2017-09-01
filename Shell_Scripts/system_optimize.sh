#!/bin/bash
# 2017年9月1日

        echo "*                -       nofile          51200" >> /etc/security/limits.conf
        ulimit -SHn 51200
        echo "sysctl -w net.ipv4.tcp_syncookies=1"  >> /etc/rc.d/rc.local
        echo "sysctl -w net.ipv4.tcp_max_syn_backlog=10000"  >> /etc/rc.d/rc.local
        echo "sysctl -w net.ipv4.tcp_synack_retries=3"  >> /etc/rc.d/rc.local
        echo "sysctl -w net.ipv4.tcp_syn_retries=3"  >> /etc/rc.d/rc.local
        echo "sysctl -p"  >> /etc/rc.d/rc.local
        echo ""  >> /etc/rc.d/rc.local
        echo '' >> /etc/sysctl.conf
        echo "/sbin/modprobe nf_conntrack" >> /etc/rc.local
        /sbin/modprobe bridge
        /sbin/modprobe nf_conntrack
        echo '' >> /etc/sysctl.conf
        echo '## resovle the problem: May  1 12:30:13 svn kernel: nf_conntrack: table full, dropping packet.' >> /etc/sysctl.conf
        echo 'net.nf_conntrack_max = 655360' >> /etc/sysctl.conf
        echo 'net.netfilter.nf_conntrack_max = 655360' >> /etc/sysctl.conf
        echo 'net.netfilter.nf_conntrack_tcp_timeout_established = 1200' >> /etc/sysctl.conf
        echo 'net.core.netdev_max_backlog = 262144' >> /etc/sysctl.conf
        echo "net.core.somaxconn = 262144" >> /etc/sysctl.conf
        echo "kernel.sem = 5010        641280   5010      512" >> /etc/sysctl.conf
        echo "vm.swappiness = 20"           >> /etc/sysctl.conf
        echo "net.ipv4.tcp_tw_reuse = 1"           >> /etc/sysctl.conf
        echo "net.ipv4.tcp_tw_recycle = 1"           >> /etc/sysctl.conf
        echo '' >> /etc/sysctl.conf
        echo 'ulimit -u 65535' >> /etc/profile
        source /etc/profile
        /sbin/sysctl -p
