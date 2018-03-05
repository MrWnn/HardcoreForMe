#!/usr/bin/expect 

#set 设置变量 [lindex $argv 0] 变量位置
#send：用于向进程发送字符串
#expect：从进程接收字符串
#spawn：启动新的进程
#interact：允许用户交互
#expect eof 不允许用户交互

#设定超时时间
#设定脚本参数1：用户名
#设定脚本参数2：密码
set timeout 10  
set username [lindex $argv 0]  
set password [lindex $argv 1]

#调用 useradd 命令添加用户
#结束调用
#调用 passwd 命令修改密码
spawn useradd $username
expect eof
spawn passwd $username

#设置期待接收到的特殊文本，这里做一层嵌套接上第二次确认密码，需要更多次确认的可用循环方式
expect {
        "Enter new UNIX password:" {
        send "$password\r"
        expect {
                        "Retype new UNIX password:" {
                        send "$password\r"
                        }
                }
        }
}

#允许用户交互
interact
