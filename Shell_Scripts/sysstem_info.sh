#!/bin/bash
# config
max_usage=90
bar_width=50
# colors
white="\e[39m"
green="\e[1;32m"
red="\e[1;31m"
dim="\e[2m"
undim="\e[0m"

# get load averages
IFS=" " read LOAD1 LOAD5 LOAD15 <<<$(cat /proc/loadavg | awk '{ print $1,$2,$3 }')
# get free memory
IFS=" " read USED FREE TOTAL <<<$(free -htm | grep "Mem" | awk {'print $3,$4,$2'})
# get processes
PROCESS=`ps -eo user=|sort|uniq -c | awk '{ print $2 " " $1 }'`
PROCESS_ALL=`echo "$PROCESS"| awk {'print $2'} | awk '{ SUM += $1} END { print SUM }'`
PROCESS_ROOT=`echo "$PROCESS"| grep root | awk {'print $2'}`
PROCESS_USER=`echo "$PROCESS"| grep -v root | awk {'print $2'} | awk '{ SUM += $1} END { print SUM }'`
# get processors
PROCESSOR_NAME=`grep "model name" /proc/cpuinfo | cut -d ' ' -f3- | awk {'print $0'} | head -1`
PROCESSOR_COUNT=`grep -ioP 'processor\t:' /proc/cpuinfo | wc -l`


echo -e "
$white System Info:
$white  IP......: $white`ifconfig  |grep enp0s3 -A1|grep 192|grep inet |awk '{print $2}'`
$white  Distro......: $white`cat /etc/redhat-release`
$white  Kernel......: $white`uname -sr`
$white  Uptime......: $white`uptime `
$white  Load........: $green$LOAD1$white (1m), $green$LOAD5$white (5m), $green$LOAD15$white (15m)
$white  Processes...:$white $green$PROCESS_ROOT$white (root), $green$PROCESS_USER$white (user), $green$PROCESS_ALL$white (total)
$white  CPU.........: $white$PROCESSOR_NAME ($green$PROCESSOR_COUNT$white vCPU)
$white  Memory......: $green$USED$white used, $green$FREE$white free, $green$TOTAL$white total$white"

# disk usage: ignore zfs, squashfs, tmpfs & overlay

mapfile -t dfs < <(df -H -x zfs -x squashfs -x tmpfs -x devtmpfs -x overlay --output=target,pcent,size,used | tail -n+2)
printf "\nDisk Usage:\n"

for line in "${dfs[@]}"; do
    # get disk usage
    usage=$(echo "$line" | awk '{print $2}' | sed 's/%//')
    used_width=$((($usage*$bar_width)/100))
    # color is green if usage < max_usage, else red
    if [ "${usage}" -ge "${max_usage}" ]; then
        color=$red
    else
        color=$green
    fi
    # print green/red bar until used_width
    bar="[${color}"
    for ((i=0; i<$used_width; i++)); do
        bar+="="
    done
    # print dimmmed bar until end
    bar+="${white}${dim}"
    for ((i=$used_width; i<$bar_width; i++)); do
        bar+="="
    done
    bar+="${undim}]"
    # print usage line & bar
    echo "${line}" | awk '{ printf("%-31s%+3s ( %+4s / %+4s )\n", $1, $2, $4, $3); }' | sed -e 's/^/  /'
    echo -e "${bar}" | sed -e 's/^/  /'
done
