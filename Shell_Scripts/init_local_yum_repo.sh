#!/bin/bash
#此脚本需要配合nginx来制作本地源服务器

work_dir=$(cd `dirname $0`;pwd)
name=`echo $1 |awk -F. '{print $1}'`
repo=`yum repolist ${name} |grep -A1 "repo id" |grep -v "repo id"|awk '{print $1}'`
domain_name=repo.local.asdasdasd.com
cdate=`date +%Y-%m-%d-%H-%M-%S`

#检查即将制作的本地源是否存在
local_repo=`yum repolist ${name} |grep -A1 "repo id" |grep -v "repo id" |grep local |grep ${repo}|awk '{print $1}'`
test ! -z "${local_repo}" && echo ${local_repo} 已存在，退出 && exit 1

#检查磁盘分区是否有单独区分/var目录
pre_check=`df -h |grep var|wc -l`
[[ "${pri_check}" != "0" ]] && df -h|grep var  && echo 注意分区/var 的大小是否满足当前软件源... && sleep 5

#检查原始源是否存在
[[ "${name}" == "" || "${repo}" == "" ]] && echo 找不到对应的软件源 “${name}” && exit 1

#安装必备软件
yum install yum-utils createrepo -y

#创建本地源目录，默认创建在 /var/www/html/localyum
chown  nobody.nobody /var/www/html/
sudo -u nobody sh -c  "test ! -d /var/www/html/localyum/${repo} && mkdir -p /var/www/html/localyum/${repo}" || exit 1 

#同步软件源内容到对应目录
reposync -r ${repo} -p /var/www/html/localyum/${repo} || exit 1

#第一个目录是repodata存放目录，第二个目录是需要生成索引信息yum源仓库目录
createrepo -pdo /var/www/html/localyum/${repo}/ /var/www/html/localyum/${repo}/ || exit 1

#备份原始源
test -e /etc/yum.repos.d/${repo}.repo && mv /etc/yum.repos.d/${repo}.repo /etc/yum.repos.d/${repo}.repo.bak.${cdate}

#写入本地源配置
echo "配置本地源"
echo -e "[${repo}]
name=local ${repo} repo store
baseurl=http://${domain_name}/${repo}
enabled=1
gpgcheck=0
" |tee -a  /etc/yum.repos.d/${repo}.repo
echo "127.0.0.1 ${domain_name}" >> /etc/hosts


#写入本地源nginx配置

if [ ! -e /usr/local/nginx/conf/vhost/${domain_name}.conf ];then
    /bin/cp -vf /usr/local/nginx/conf/vhost/example.conf /usr/local/nginx/conf/vhost/${domain_name}.conf
    sed -i "s#example-domain#${domain_name}#g" /usr/local/nginx/conf/vhost/${domain_name}.conf
    sed -i "s#example-dir#\/var\/www\/html\/localyum\/#g" /usr/local/nginx/conf/vhost/${domain_name}.conf
    /etc/init.d/nginx reload
fi

yum clean all
yum makecache

echo "已完成本地源${repo}" && exit 0
