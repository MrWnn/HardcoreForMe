#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import MySQLdb
import json

db = MySQLdb.connect("127.0.0.1","root","121212","mysql",4580)

cursor = db.cursor()

cursor_str=("select user,host,password from user where user = 'root';")

cursor.execute(cursor_str)

data = cursor.fetchall()


for i in data: 
    print "%s-%s-%s" %(i[0],i[1],i[2])
    #print i[0]
    #print i[1]
    #print i[2] 

db.close()

