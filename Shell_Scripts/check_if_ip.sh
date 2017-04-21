#!/bin/bash
CHECK_IF_IP()
{
        IP=$1
        if [[ `echo ${IP}|grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$"|wc -l` != 1 ]]
        then
                echo -e "\nRequire valid IP input\n"
                exit
        else 
                A_part=`echo ${IP}|awk -F. '{print $1}'`
                B_part=`echo ${IP}|awk -F. '{print $2}'`
                C_part=`echo ${IP}|awk -F. '{print $3}'`
                D_part=`echo ${IP}|awk -F. '{print $4}'`
                for ad_parts in ${A_part} ${D_part} 
                do 
                        if [ ${ad_parts} -ge 255 ]||[ ${ad_parts} -le 0 ]|| [ `echo ${ad_parts} |grep "^0.\{1,3\}" |wc -l` -eq 1  ] 
                        then 
                                echo -e "\n Invalid IP ${IP} input"
                                exit
                        fi
                done
                for bc_parts in ${B_part} ${C_part}
                do
                        if [ ${bc_parts} -ge 255 ]||[ ${bc_parts} -lt 0 ]|| [ `echo ${bc_parts} |grep "^0.\{1,3\}" |wc -l` -eq 1  ] 
                        then 
                                echo -e "\n Invalid IP ${IP} input"
                                exit
                        fi
                done
        fi
}
CHECK_IF_IP $1
