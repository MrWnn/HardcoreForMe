#!/usr/bin/env python
# -*- coding: utf-8 -*-

# shell version logic to get physical server list
##id=`echo "use abc_admin;select * from game_plat_group "|mysql -P3360 -h127.0.0.1 -uroot -p${password} |grep ^[0-9]|sed "s/\t/-/"`;echo $id
#for ids in `echo "use abc_admin;select * from game_plat_group "|mysql -P3360 -h127.0.0.1 -uroot -p${password} |grep ^[0-9]|sed "s/\t/-/"`;do
#    id=`echo $ids|awk -F- '{print $1}'`
#    name=`echo $ids|awk -F- '{print $2}'`
#    echo
#    echo $id $name
#    echo "use abc_admin;select server_ip from physical_server_list where allow_add = 1 and group_id='${id}';"|mysql -P3360 -h127.0.0.1 -uroot -p${password} |grep [0-9]|sort |uniq
#    echo -e "共  \c";echo "use abc_admin;select server_ip from physical_server_list where allow_add = 1 and group_id='${id}';"|mysql -P3360 -h127.0.0.1 -uroot -p${password} |grep [0-9]|sort |uniq|wc -l
#done

import MySQLdb
import json
import sys
import requests
import commands
import re

# to get the local master ip
get_ip_url = 'http://members.3322.org/dyndns/getip'

# get the physical server list in cmdb
def get_physical_server_list():
    MysqlHost = '127.0.0.1'
    MysqlPass = '121212'
    MysqlUser = 'root'
    MysqlPort = 3360
    db = MySQLdb.connect(MysqlHost,MysqlUser,MysqlPass,"mysql",MysqlPort,charset='utf8')
    
    cursor = db.cursor()
    cursor_get_group_id=("select * from abc_admin.game_plat_group;")
    cursor.execute(cursor_get_group_id)
    data = cursor.fetchall()
    for i in data:
        cursor_get_physical_server_list=("select server_ip from abc_admin.physical_server_list where allow_add = 1 and group_id=%s" %(i[0]))
        cursor.execute(cursor_get_physical_server_list)
        data1 = cursor.fetchall()
        db.close()
        return data1
    db.close()
 
# get the salt minions list from local salt-key list
def get_minions():
    minions =  commands.getoutput("salt-key |awk '/Acc/,/Den/{if(i>1)print x;x=$0;i++}'|awk -F- '{print $2}'")
    return minions

# compare two of the list above and find the ip not in physical server list
def get_offline_minion(url):
    P_get = requests.get(url)
    exclude =  P_get.text
    psl = str(get_physical_server_list())
    ms = tuple(re.split('\n', get_minions()))
    
    for off in ms:
        if  off not in psl:
            if off not in exclude:
                print off,'已下架'
                print off
            else:
                print "无下架 minion"

if __name__ == '__main__':
    get_offline_minion(get_ip_url)
