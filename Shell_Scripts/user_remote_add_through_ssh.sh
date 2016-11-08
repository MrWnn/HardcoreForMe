#!/bin/bash

SUDOER=$1
USER_ADD=$2
USER_PUB_FILE=`basename $3 2>/dev/null`
USER_PUB_PATH=`dirname $3 2>/dev/null`
USER_PASS=$4
IP_ADD_USER=$5

SSH_PORT=${The_ssh_p0rt_you_need}
SSH_KEY=${s0me_where_your_ssh_key_lay}
GROUP=${The_user_gr0up_you_need_t0_set}

USAGE_SCRIPT()
{
	echo -e "\n 用法： user_add_wheel_group.sh [远程免密执行用户名] [新增用户名] \
	 [路径/新增用户公钥名] [新增用户密码] [目标IP（可输入多个IP）]  \
	\n       (如果被添加用户的公钥与脚本执行路径一致就无需补足该公钥路径) \n"
	echo -e "例子: ./`basename $0` remote_sudoer_name test /home/MrWnn/.ssh/authorized_keys test_password 192.168.1.1 192.168.1.2\n"
	exit
	# [sudoer] [user] [path/rsa_pub_file] [user_password] [ip(1~n)]\n"
	
}	

CHECK_RSA_SUDOER()
{
        if [ ! -e ${SSH_KEY} ]
        then
                echo -e "\n     ${SSH_KEY} not exist! Please check. \n"
                exit
        fi
}

CHECK_IF_IP()
{
	if [[ `echo ${IP_ADD_USER}|grep "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$"|wc -l` != 1 ]]
	then
		echo -e "\nRequire valid IP input\n"
		exit
	fi
}

CHECK_RSA_PUBKEY()
{
	if [ ! -e $USER_PUB_PATH/${USER_PUB_FILE} ]
	then 
		echo -e "\n$USER_PUB_PATH/${USER_PUB_FILE} not exist\n"
		exit
	fi
}

REMOTE_ADD_IP()
{
	echo ${IP_ADD_USER}
	CHECK_IF_IP
	echo "copy ${USER_PUB_PATH}/${USER_PUB_FILE} to ${1}..."
	/usr/bin/scp -rCp -P${SSH_PORT} -i ${SSH_KEY} ${USER_PUB_PATH}/${USER_PUB_FILE} ${SUDOER}@${1}:/home/${SUDOER}/
	command[1]="sudo /usr/sbin/useradd ${USER_ADD} -g ${GROUP}"
	command[2]="sudo /bin/echo ${USER_PASS}|sudo passwd --stdin ${USER_ADD}"	
	command[3]="sudo /bin/mkdir  /home/${USER_ADD}/.ssh "
	command[4]="sudo /bin/mv /home/${SUDOER}/${USER_PUB_FILE} /home/${USER_ADD}/.ssh/authorized_keys"
	command[5]="sudo /bin/chown -R ${USER_ADD}:wheel /home/${USER_ADD}/.ssh"
	command[6]="sudo /bin/chmod 700 /home/${USER_ADD}/.ssh"
	command[7]="sudo /bin/chmod 600 /home/${USER_ADD}/.ssh/authorized_keys"
	command[8]="sudo /bin/chown ${USER_ADD}:wheel /home/${USER_ADD}/.ssh/authorized_keys"
	name[1]="add ${USER_ADD}"
	name[2]="change pass ${USER_ADD}"
	name[3]="create home ${USER_ADD}"
	name[4]="move USER_PUB_FILE to ${USER_ADD} home"
	name[5]="change own ${USER_ADD} of KEY_DIR"
	name[6]="change mod 700 of KEY_DIR"
	name[7]="change mod 600 of SSH_KEY"
	name[8]="change own ${USER_ADD} of SSH_KEY"
	for(( i=1; i<=8; i++ ))
	do
		echo "dealing command${i}: ${name[$i]}"
		ssh -i ${SSH_KEY} -p${SSH_PORT} -l${SUDOER} ${1} "${command[$i]}"
	done
}

#########
# start #
#########

if [[ $# < 5 ]]
then
	USAGE_SCRIPT
fi
CHECK_RSA_SUDOER
CHECK_RSA_PUBKEY

while [[ $# != 4 ]]
do
	USER_COUNT="sudo cat /etc/passwd |grep ${USER_ADD}|wc -l"
    REMOTE_CHECK=`ssh -i ${SSH_KEY} -p${SSH_PORT} -l${SUDOER} ${IP_ADD_USER} "${USER_COUNT}"`
        if [[ ${REMOTE_CHECK} == 1 ]]
        then    
                echo -e "	${IP_ADD_USER}: User ${USER_ADD} exist"
				shift
				IP_ADD_USER=$5
                continue
        fi
 	REMOTE_ADD_IP ${IP_ADD_USER}
	shift
	IP_ADD_USER=$5
done

unset command i SUDOER SSH_KEY USER_ADD USER_PUB_FILE USER_PUB_PATH USER_PASS IP_ADD_USER USER_COUNT REMOTE_CHECK \
 SSH_PORT GROUP
