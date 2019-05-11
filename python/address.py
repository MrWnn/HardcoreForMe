#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# get address 

import json
import requests

#计算sn,对接地图接口,未调通
import urllib
import hashlib

# 定义一个地址类
class Address(object):
	#初始化地址类,定义属性
	def __init__(self, address=None, location=None):
		self._address = address 
		self._location = location
		self._component = None
		self._base_url = "http://api.map.baidu.com"
		#self._params = {'output': 'json','ak': 'GRlG8i8IeHcup08GR77s5LHGPk27kBlT'}
		self._params = {'output': 'json','ak': 'ls1IAUfpB7Bt6KNUb7uB2DQ7itG17Zd7'}
		
	@property
	def address(self):
		return self._get_address()
	
	@property
	def location(self):
		return self._location if self._location else self._get_location()
	
	@property
	def province(self):
		self._set_address()
		return self._component['province']
	
	@property
	def city(self):
		self._set_address()
		return self._component['city']
		
	@property
	def district(self):
		self._set_address()
		return self._component['district']
		
	def route(self, address):
		return self._get_route_info(address)
	
	def _set_address(self):
		if not self._component:
			self._address = self._get_address()
	
	def _get_route_info(self, address):
		func_url = '/routematrix/v2/driving'
		
		#ak='ls1IAUfpB7Bt6KNUb7uB2DQ7itG17Zd7'
		## sn gen /geocoder/v2/?address=百度大厦&output=json&ak=yourak
		#queryStr = func_url+'?address='+self._address+'&output=json&ak={}'.format(ak)
		#print(queryStr)
		#encodedStr = urllib.parse.quote(queryStr, safe="/:=&?#+!$,;'@()*[]")
		#rawStr = encodedStr + ak
		#sn = hashlib.md5(urllib.parse.quote_plus(rawStr).encode('utf-8')).hexdigest()
		
		origin = ','.join(map(str, self.location))
		destination = ','.join(map(str, address.location))
		params = self._params.copy()
		params.update(origins=origin, destinations=destination)
		#print(params)
		result = requests.get(self._base_url + func_url,params=params)
		data = json.loads(result.text)
		#print(data)
		if data['status'] == 0:
			return {
				'duration': data['result'][0]['duration']['value'],
				'distance': data['result'][0]['distance']['value']
				}
		else:
			return None
			
	def _get_location(self):
		func_url = '/geocoder/v2/'
		
		#ak='ls1IAUfpB7Bt6KNUb7uB2DQ7itG17Zd7'
		## sn gen /geocoder/v2/?address=百度大厦&output=json&ak=yourak
		#queryStr = func_url+'?address='+self._address+'&output=json&ak={}'.format(ak)
		#print(queryStr)
		#encodedStr = urllib.parse.quote(queryStr, safe="/:=&?#+!$,;'@()*[]")
		#rawStr = encodedStr + ak
		#sn = hashlib.md5(urllib.parse.quote_plus(rawStr).encode('utf-8')).hexdigest()
		
		params = self._params.copy()
		params.update(address=self._address)
		#print(params)
		result = requests.get(self._base_url + func_url, params)
		data = json.loads(result.text)
		#print(data)
		if data['status'] == 0:
			return data['result']['location']['lat'], data['result']['location']['lng']
		else:
			return None
			
			
	def _get_address(self):
		if not self._component:
			func_url = '/geocoder/v2/'
			
			#ak='ls1IAUfpB7Bt6KNUb7uB2DQ7itG17Zd7'
			## sn gen /geocoder/v2/?address=百度大厦&output=json&ak=yourak
			#queryStr = func_url+'?address='+self._address+'&output=json&ak={}'.format(ak)
			#print(queryStr)
			#encodedStr = urllib.parse.quote(queryStr, safe="/:=&?#+!$,;'@()*[]")
			#rawStr = encodedStr + ak
			#sn = hashlib.md5(urllib.parse.quote_plus(rawStr).encode('utf-8')).hexdigest()
			
			params = self._params.copy()
			params.update(location=",".join(map(str, self.location)))
			#print("在这里",params)
			result = requests.get(self._base_url + func_url,params)
			data = json.loads(result.text)
			#print(data)
			if data['status'] == 0:
				self._component = data['result']['addressComponent']
				self._address = data['result']['formatted_address'] + data['result']['sematic_description']
			else:
				return None
		return self._address
			
			
			
			
	
	if __name__ == '__main__':
		# example		
		addr 	= Address(address="华南师范大学石牌校区")
		print(addr.address)
		print(addr.location)
		print(addr.province)
		print(addr.city)
		print(addr.district)
		print()
		
		addr_2 = Address(location=(40,116))
		print(addr_2.address)
		print(addr_2.location)
		print(addr_2.province)
		print(addr_2.city)
		print(addr_2.district)
		print()
		
		print(addr_2.route(addr))
		print(Address.route(addr_2, addr))
		print(Address.route(addr_2, addr))
		print(Address.route(addr_2, addr))
		print(Address.route(addr_2, addr))
		
		
		
		
		
		
		
		
		
		
		
		
		
