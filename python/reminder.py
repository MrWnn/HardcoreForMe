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
