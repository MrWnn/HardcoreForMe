#!/usr/bin/env python
# -*- coding: utf-8 -*-

import MySQLdb
import json
import sys
import requests
import commands
import re

get_ip_url = 'http://members.3322.org/dyndns/getip'

# From cmdb get physical_server_list
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
    print len(data)
    data1 = []
    for i in range(len(data)):
        cursor_get_physical_server_list=("select server_ip from ssqy_admin.physical_server_list where allow_add = 1 and group_id=%s" %(data[i][0]))
        cursor.execute(cursor_get_physical_server_list)
        data1.append(cursor.fetchall())
    db.close()
    return data1

# From salt-key get salt_minions_list
def get_minions():
    minions =  commands.getoutput("salt-key |awk '/Acc/,/Den/{if(i>1)print x;x=$0;i++}'|awk -F- '{print $2}'")
    return minions

# Compare physical_server_list salt_minions_list and get the offline minions
def get_offline_minion(url):
    P_get = requests.get(url)
    exclude =  P_get.text
    psl = str(get_physical_server_list())
    ms = tuple(re.split('\n', get_minions()))
    for off in ms:
        if  off not in exclude:
            if off not in psl:
                print off,'已下架'
                print off

if __name__ == '__main__':
    get_offline_minion(get_ip_url)
