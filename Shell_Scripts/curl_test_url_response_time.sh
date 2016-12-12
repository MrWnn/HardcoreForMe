#!/bin/bash
START_DATE=`date +%Y-%m-%d-%H-%M-%S`
TIMESTAMP=`date +%s`
START_DAY=`date +%d`
ROOT_DIR=/var/log/curl/
TARGET_URL=https://www.baidu.com/index.html?v=${TIMESTAMP}

#value from http://www.whoishostingthis.com/tools/user-agent/
REQUEST_HEAD_AGENT="Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0"
#REDEFINE_HEAD_AGENT="User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0"

test -d ${ROOT_DIR} || mkdir ${ROOT_DIR}
cd ${ROOT_DIR}

if [[ $# == 0 ]]
then
curl -o /dev/null \
        -A"${REQUEST_HEAD_AGENT}"  -v -s -w \
        "start_time""\t"http_code"\t"http_connect"\t"content_type"\t"time_namelookup"\t"time_connect"\t"time_appconnect"\t"time_redirect"\t"time_pretransfer"\t"time_starttransfer"\t"time_total"\t"speed_download"\n"\
"${START_DATE}""\t"%{http_code}"\t"%{http_connect}"\t"%{content_type}"\t"%{time_namelookup}"\t"%{time_connect}"\t"%{time_appconnect}"\t"%{time_redirect}"\t"%{time_pretransfer}"\t"%{time_starttransfer}"\t"%{time_total}"\t"%{speed_download}"\n" \
        --compressed \
        ${TARGET_URL} >>day_${START_DAY}  2>&1
fi

##to be continued


