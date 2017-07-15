# -*- coding:utf-8 -*-
_author_ = 'mrwnn'
# a=1
# print("")
# print(a.upper())
# print(" asd".lstrip())
# print("a"+"b")
# import this
# cmd_list = ['ls','pwd','vnstat','iostat']

# print strings
print("hello asdasd")
print("hello\nasdasd")

# variable operator
a="asd"
print(a.upper())
print(" asd asd ".lstrip())
print("a"+"b")

#list operator
cmd_list = ['ls','pwd','vnstat','iostat']
print(cmd_list)
print(cmd_list[0])
print(cmd_list[1])

sort_list = [ '6','3','5','4' ]
print sort_list
sort_list.sort()
print sort_list

for i in range(0,len(cmd_list)):
    print(cmd_list[i])

# triple subjects operator
b=1;c=2
print b>c and b or c 

#list cuter and the list copy 
print sort_list[0:]
print sort_list[:4]

pointer_list = sort_list
print pointer_list
sort_list.append(7)
pointer_list.append(8)
print sort_list
print pointer_list
print "this is the pointer , not the copy"

copy_list = sort_list[:]
print copy_list
sort_list.append(9)
copy_list.append(10)
print sort_list
print copy_list
print "this is the copy list"
