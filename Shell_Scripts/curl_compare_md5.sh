#!/bin/bash

WARNING () {
echo -e "\033[0;31;1m$*\033[0m\n"
}
GREEN(){
    echo -e "\033[1;32m$*\033[0m\n"
}


RAN=$(echo ${RANDOM:0:5})
for i in 1 2 3 4 5 6 7 8 9 10 ;do 
curl -s  "http://my-cdnres.mrwnn.com/cdnconfig_${RAN}/stable/android_cn/platform/very_important_cfg.xml"  -o very_important_cfg.xml1
A=$(md5sum very_important_cfg.xml1|awk '{print $1"-"$2}')
B=$(md5sum /data/www/my_cdn/stable/android_cn/platform/very_important_cfg.xml|awk '{print $1"-"$2}')

md4=$(echo $A |awk -F- '{print $1}')
name1=$(echo $A |awk -F- '{print $2}')
md5=$(echo $B |awk -F- '{print $1}')
name2=$(echo $B |awk -F- '{print $2}')


if [[ $md4 != $md5 ]];then
    WARNING $md4 $name1
    WARNING $md5 $name2  
else 
    GREEN $md4 $name1
    GREEN $md5 $name2
fi
rm -fv very_important_cfg.xml1
done
