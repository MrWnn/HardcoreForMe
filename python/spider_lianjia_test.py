# 爬虫练习
# https://bj.lianjia.com/zufang/ 
# 环境准备
# pip install bs4
# pip isntall lxml
# pip install requests 
# 创建数据库

# create database renting_lianjia;
# CREATE TABLE `spider_catch` (
#   `id` int(11) NOT NULL AUTO_INCREMENT,
#   `link` varchar(60) DEFAULT NULL,
#   `info` json DEFAULT NULL,
#   PRIMARY KEY (`id`)
# ) ENGINE=InnoDB AUTO_INCREMENT=2428 DEFAULT CHARSET=utf8;
#from __future__ import unicode_literals

import re
import requests
import MySQLdb
import json
import progressbar
from bs4 import BeautifulSoup


headers = {'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) '
           'Chrome/51.0.2704.63 Safari/537.36'}
url = 'https://gz.lianjia.com'
uri = '/zufang/'
#uri = 'pg1/#contentList'

database = {
    'host':'127.0.0.1',
    'database':'renting_lianjia',
    'user':'root',
    'password':'wnn519',
    'charset':'utf8mb4' # 定义字符集
}



# 利用 request 包的get 获取连接htmnl内容
#response = requests.get(url+uri,headers = headers, timeout = 30)
#print(response)
#  
#soup = BeautifulSoup(response.text,'lxml')
#links = soup.find_all('div',class_='content__list--item') 
#links_resolve = [ url+link.a.get('href') for link in links ]
#a = links_resolve,len(links_resolve)

#以上步骤封装为函数
def get_work_link(url,uri,headers,timeout,parser):
    try:
        response = requests.get(url+uri,headers = headers, timeout = 30)
        soup = BeautifulSoup(response.text,'lxml')
        links = soup.find_all('div',class_='content__list--item') 
        links_resolve = [ url+link.a.get('href') for link in links ]
        links_resolve,len(links_resolve)
        return links_resolve
    except Exception as err:
        return err

def get_page(url,headers,timeout,parser):
    try:
        response_get_page = requests.get(url,headers=headers,timeout=timeout)
        soup_get_page = BeautifulSoup(response_get_page.text,parser)
        return soup_get_page
    except Exception as err_get_page:
        return err_get_page
        
#def get_link(link_url):
#    try:
#        soup_get_link = get_page(link_url)
#        links = soup.find_all('div',class_='content__list--item') 
#        links_resolve = [ url+link.a.get('href') for link in links ]
#        return links_resolve
#    except Exception as err:
#        return err

#def get_raw_data(url,class_):
#    if 'apartment' in url:
#            
#    else:
#        try:
#            soup = get_page(url,headers,30,'lxml')
#            #result = soup.find('div',class_ = 'content clear w1150').text.strip().split('\n')
#            result = soup.find('div',class_ = class_).text.strip().split('\n')
#            results = [ value.strip() for value in result if value != '' ]
#            return results
#        except Exception as err:
#           return err
def get_apartment_info(get_apartment_info_url):
    if 'apartment' in get_apartment_info_url:
        try:
            info_url = get_apartment_info_url
            soup_get_apartment = get_page(info_url,headers,60,'lxml')
            try:
                name = soup_get_apartment.find('span',class_ = 'aside_neme').text #疑似拼写错误
                price = list(soup_get_apartment.find('p',class_ = 'content__aside--title').find('span',class_='').stripped_strings)
                description = soup_get_apartment.find('p',class_ = 'flat__info--description threeline').text
                try:
                    contact_info = list(soup_get_apartment.find('p',class_ = 'flat__info--subtitle online').stripped_strings)
                    locate = contact_info[0]
                    tel = contact_info[1]
                except Exception as err:
                    print(err)
                    locate = "无描述信息"
                    tel = "无描述信息"
            except AttributeError as err:
                return "get_apartment_value error",err
            info = {
                'apartment_name':name,
                'apartment_price':price,
                'apartment_description':description,
                'apartment_address':locate,
                'apartment_tel':tel               
            }
            return json.dumps(info,ensure_ascii=False)
        except ValueError as err:
            return "get_apartment_info err",err


#def get_house_info(house_info):
def get_house_info(get_house_info_url):
    if 'apartment' not in get_house_info_url:
    #return json.dumps({'品牌公寓':'暂时不支持查看'},ensure_ascii=False)
    #else:
        try:
            info_url = get_house_info_url
            soup_get_house = get_page(info_url,headers,60,'lxml')
            try:
                name = soup_get_house.find('p',class_ = 'content__title').text #住房名称
                uptime = soup_get_house.find('div', class_ = 'content__subtitle').text.strip().split(' ')[2] #上架时间
                price = list(soup_get_house.find("div",class_ = 'content__aside fr').find('p',class_ = 'content__aside--title').stripped_strings) #价格
                detail = list(soup_get_house.find("div",class_ = 'content__aside fr').find('p',class_ = 'content__aside--tags').stripped_strings) #详细特性 
            except AttributeError as err:
                return "get_house_value error",err
            
            try:
                basic_info = list(soup_get_house.find("div",class_ = 'content__article__info').find('ul').stripped_strings)
                rentable = basic_info[2][3:] #是否可租
                rentperiod = basic_info[3][3:] #租期
                appointment = basic_info[4][3:] #提前预约
                level = basic_info[5][3:] #楼层
                elevator = basic_info[6][3:] #电梯
                water = basic_info[8][3:] #用水
                electric = basic_info[9][3:] #用电
                gas = basic_info[10][3:] #燃气
                warm = basic_info[11][3:] #采暖
            except Exception as err:
                print('basic_err',err)
                rentable = "无描述信息" #是否可租
                rentperiod = "无描述信息" #租期
                appointment = "无描述信息" #提前预约
                level = "无描述信息" #楼层
                elevator = "无描述信息" #电梯
                water = "无描述信息" #用水
                electric = "无描述信息" #用电
                gas = "无描述信息" #燃气
                warm = "无描述信息" #采暖
                
            try:
                more_info = list(soup_get_house.find("div",class_ = 'content__article__info3').find('p',class_ = 'threeline').stripped_strings)
                des = more_info[0:1] #描述
                trans = more_info[1:2] #交通
                why = more_info[2:3] #出租原因
            except Exception as err:
                des = "无描述信息"
                trans = "无描述信息"
                why = "无描述信息"
            
            info = {
                'house_name':name,
                'house_uptime':uptime,
                'house_rentable':rentable,
                'house_rentperiod':rentperiod,
                'house_appointment':appointment,
                'house_level':level,
                'house_elevator':elevator,
                'house_water':water,
                'house_electric':electric,
                'house_gas':gas,
                'house_warm':warm,
                'house_description':des,
                'house_transport':trans,
                'house_renting_reason':why,
                'house_price':price,
                'house_detail':detail
            }
            return json.dumps(info,ensure_ascii=False)
        except ValueError as err:
            return "get_house_info err",err
                              
def local_db_store(database_info,sql):
    #link = url
    #renting_info = json_str
    database = database_info
    sql_q = sql 
    db = MySQLdb.connect(**database)
    cursor_local = db.cursor()
    try:
        cursor_local.execute(sql_q)
        db.commit()
        db.close()
    except Exception as err:
        db.commit()
        db.close()
        return "insert error",err

def adjust_modle_lianjia(link_url):
    adjust_link = link_url
    if 'apartment' in adjust_link:
        return get_apartment_info(adjust_link)
    else:
        return get_house_info(adjust_link)
        


# 入库
# Need Mysql
# create database 
count = 0
for page in range(1,101):
    page="pg{}/#contentList".format(page)
    uri_page=uri+page
    house_url = get_work_link(url,uri_page,headers,30,'lxml')
    for each_url in house_url:
    #    raw_data = get_raw_data(url,'content clear w1150') 
        sql_q = "insert into spider_catch (link,info) value ('{}','{}')".format(each_url,adjust_modle_lianjia(each_url))
        local_db_store(database,sql_q)
        count += 1
        sys.stdout.write('{},{},{}\r'.format(count,each_url,adjust_modle_lianjia(each_url)))
        sys.stdout.flush()
