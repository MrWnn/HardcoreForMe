#!/usr/bin/env python
# -*- coding: utf-8 -*-

import MySQLdb
import json
import sys
import requests
import commands
import re


def print_help():
    print ('\n 用法: sh %s [minion/log] ' %sys.argv[0])
    exit(1)

# in this function,using a inefficient way to get  ip list from cmdb as a Reverse example.
def get_physical_ip_list():
    MysqlHost = '127.0.0.1'
    MysqlPass = '121212'
    MysqlUser = 'root'
    MysqlPort = 3360
    db = MySQLdb.connect(MysqlHost,MysqlUser,MysqlPass,"mysql",MysqlPort,charset='utf8')
    cursor = db.cursor()
    cursor_get_group_id=("select * from admin.minion_group;")
    cursor.execute(cursor_get_group_id)
    data = cursor.fetchall()
    print len(data)
    data1 = []
    for i in range(len(data)):
        cursor_get_physical_ip_list=("select ip from admin.physical_ip_list where allow_add = 1 and group_id=%s" %(data[i][0]))
        cursor.execute(cursor_get_physical_ip_list)
        data1.append(cursor.fetchall())
    db.close()
    return data1
 
# in this function ,using a inner join sql but still too long, have no idea about shortening it.
def get_log_ip_list():
    MysqlHost = '127.0.0.1'
    MysqlPass = '121212'
    MysqlUser = 'root'
    MysqlPort = 3360
    db = MySQLdb.connect(MysqlHost,MysqlUser,MysqlPass,"mysql",MysqlPort,charset='utf8')
    cursor = db.cursor()
    #cursor_get_group_id=("select * from admin.minion_group;")
    #cursor.execute(cursor_get_group_id)
    #data = cursor.fetchall()
    #print len(data)
    data1 = []
    #for i in range(len(data)):
    cursor_get_log_server_list=("select distinct(ip) from admin.log_ip_list inner join admin.minion_group where allow_add = 1 and admin.log_ip_list.group_id = admin.minion_group.id ;")
    cursor.execute(cursor_get_log_ip_list)
    data1.append(cursor.fetchall())
    db.close()
    return data1


def get_minions():
    minions =  commands.getoutput("salt-key |awk '/Acc/,/Den/{if(i>1)print x;x=$0;i++}'|grep %s|awk -F- '{print $2}'" %Types)
    return minions

def auto_offline_minion(url,Type):
    P_get = requests.get(url)
    exclude =  P_get.text
    if Type == 'minion':
        physical_ip = str(get_physical_ip_list())
    elif Type == 'log':
        physical_ip = str(get_log_ip_list())
    else: 
         print_help()
    minion_slaves = tuple(re.split('\n', get_minions()))
    for minion in minion_slaves:
        if  minion not in exclude:
            if minion not in physical_ip:
                print minion,'已下架'
                print minion
		print commands.getoutput("salt-key -d %s-%s -y" %(Types,minion))


if len(sys.argv) <= 1:
   print_help()

get_ip_url = 'http://members.3322.org/dyndns/getip'
Types=sys.argv[1]

if __name__ == '__main__':
    auto_offline_minion(get_ip_url,Types)
