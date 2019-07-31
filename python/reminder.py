#!/usr/bin/env python
# -*- coding:utf-8 -*-
_author_ = "mrwnn"
_version_ = "python3"
a=1
b=2
print(a==b and a or b)

sort_list = [ '6','3','5','4' ]
print(sort_list)
sort_list.sort()
print(sort_list)
while "3" in sort_list:
    print "3 in one"
    break
while "0" not in sort_list:
    print "0 not in one"
    break
print(sort_list)
if a>b:
    print(a)
else:
    print("b",b)

print(sort_list[0:])
print(sort_list[:4])

pointer_list = sort_list
print(pointer_list)
sort_list.append(7)
pointer_list.append(8)
print(sort_list)
print(pointer_list)
print("this is the pointer , not the copy")

copy_list = sort_list[:]
print copy_list
sort_list.append(9)
copy_list.append(10)
print(sort_list)
print(copy_list)
print("this is the copy list")

#tuple
tuple_list = ("a","b")
print ("this is tuple")
print (tuple_list[0])
print (tuple_list[1])

booler = 'print ( 1 == 1 )'
if  booler== True:
    print ("True here")
else:
    print(booler)
if 6 in sort_list:
    print("yes")
else:
    print("no")
aliens = [ 'alien1','alien2','alien3' ]
for aliener in aliens:
    if aliener == "alien1":
        print ("green")
    elif aliener == "alien2":
        print ("red")
    elif aliener == ("alien3"):
        print ("blue")
    else:
        print ("fuckoff")
alient_0={'color':'green','point':'5'}
position_a0={'x':11,'y':5,'z':3}
if position_a0['x'] == 11 :
    print("alient_0 go to "+ str(position_a0['x']))
elif position_a0['y'] == 5:
    print(position_a0)

del alient_0['point']
print(alient_0)
alient_0['point']= 6
print(alient_0)

for  iters in position_a0.values():
    print(iters)
for  iters in position_a0.keys():
    print(iters)
for  k,v in position_a0.items():
    print(k,v)
for  iters in position_a0.iteritems():
    print(iters,'one iter')
for  k1,v1 in position_a0.iteritems():
    print(k1,v1,'two iter')

# in python, = equals to pointer in c, take only address
position_a1=position_a0.copy()
position_a2=position_a0
print('here is the copy: ' + str(position_a1))
print(position_a0.popitem())
print(position_a0)
print(position_a1)
print(position_a2)
