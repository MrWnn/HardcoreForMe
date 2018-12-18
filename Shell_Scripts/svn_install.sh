#!/bin/bash
# date:2018-12-18
# author: MrWnn
# Lisence: GPL3

Usage(){
	echo
	echo "Centos6 Svn 安装脚本"
	echo "用法: sh `basename $0` [svn目录名]"
	echo
	exit 1
}

svn_name=$1
svn_path=/${svn_name}
test -z "${svn_name}" && Usage || echo Param Pass
run_user_check=$(id -un)
test "${run_user_check}" != "root" && echo not root running,exit && exit 1 || echo User Pass
check_svn=$(/usr/bin/whereis {svnserve,svn} |awk -F: '{print $2}'|grep svn)
test -z "${check_svn}" && yum install -y svn || echo Svn Installed
pid_svn_check=$(ps aux |grep -v grep |grep svnserve|awk '{print $2}')
test  ! -z "${pid_svn_check}" && echo Svn Server Running,exit && exit 1 || echo Pid Svn Check Pass
test ! -d "${svn_path}" && mkdir ${svn_path} && echo Svn Dir ${svn_name} created,Plz Check if need to remount && exit 1 || echo Svn Dir Pass

CreateConf(){
	/sbin/service svnserve stop 
	conf_path=${svn_path}/conf
	authz_file=${conf_path}/authz
	passwd_file=${conf_path}/passwd
	server_file=${conf_path}/svnserve.conf

	#下面这些配置只是范例，怎么配方便自己改			
	echo "[aliases]
[groups]
yunying=wuyuanxin,chenpenghui
yunwei=wunannan
admin=wunannan
[/]
@admin=rw
[/yycenter]
@yunying=rw
@admin=rw
*= 
[/ywcenter]
@yunying=r
@yunwei=rw
*= 
" > ${authz_file}
	echo "[users]
chenpenghui = 123123
wuyuanxin = 123456
wunannan = 111111
" > ${passwd_file}

	echo "[general]
anon-access = none
auth-access = write
password-db = passwd
authz-db = authz
[sasl]
" > ${server_file}
}

StartSvn(){
	/sbin/service svnserve restart	
}

CreateConf
StartSvn
