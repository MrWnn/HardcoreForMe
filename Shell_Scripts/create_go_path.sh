#!/bin/bash
# for normaol user, not root , only centos
bashrc_file=.bashrc

user=`whoami`
test "$user" == "root" && echo this script is not for root && exit 1
echo create go work path in $HOME
echo enter the top dir without any slash:
read name
test -z "${name}" && exit 1
check_slash=`echo "$name"|grep -E "[\,/]"|wc -l`
test ! -z "${check_slash}" && test "${check_slash}" != "0" && echo "you entered slash, exit." &&exit 1
for i in src bin pkg ;do mkdir -p ${HOME}/${name}/$i;done

echo work_path: ${HOME}/$name
grep -i go ${HOME}/${bashrc_file} || echo -e "export GOPATH=\${HOME}/$name \nexport PATH=\${PATH}:\${GOPATH}/bin \n " >> ${HOME}/${bashrc_file}
