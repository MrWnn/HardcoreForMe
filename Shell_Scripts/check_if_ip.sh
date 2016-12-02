#!/bin/bash
CHECK_IF_IP()
{
        IP=$1
        if [[ `echo ${IP}|grep "^[1-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$"|wc -l` != 1 ]]
        then
                echo -e "\nRequire valid IP input\n"
                exit
        fi
}
CHECK_IF_IP $1
