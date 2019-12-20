#!/bin/bash
# 2019年7月31日
# MrWnn

#User=需要添加的sudoer
User=mrwnn
SudoerFile=/etc/sudoer.d/${User}
Sudoer=`whoami`


if [[ "${Sudoer}" != root ]];then
    echo "Need root to run this" && exit 1
fi

test ! -e ${SudoerFile} && touch ${SudoerFile} && echo -e "${User}\tALL=(ALL)\tNOPASSWD: ALL" || echo ${User} Already sudoer
