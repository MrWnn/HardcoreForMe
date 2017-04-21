#!/bin/bash
CHECK_IF_IP()
{
        IP=$1
        if [[ `echo ${IP}|grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$"|wc -l` != 1 ]]00
        then
                echo -e "\nRequire valid IP input\n"
                exit
        else 
                A_part=`echo ${IP}|awk -F. '{print $1}'`
                B_part=`echo ${IP}|awk -F. '{print $2}'`
                C_part=`echo ${IP}|awk -F. '{print $3}'`
                D_part=`echo ${IP}|awk -F. '{print $4}'`
                for parts in A_part B_part C_part D_part 
                do 
                        if [ ${parts} -ge 255 ]||[ ${parts} -le 0 ]|| [ `echo ${parts} |grep ^0 |wc -l` -eq 1  ] 
                        then 
                                echo -e "\n Invalid IP ${IP} input"
                                exit
                        fi
        fi
}
CHECK_IF_IP $1
