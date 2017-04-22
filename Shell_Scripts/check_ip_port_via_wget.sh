#!/bin/bash

CHECK_IP=$1
CHECK_PORT
STATUS=1

CHECK_WGET=`whereis wget |grep \/wget|wc -l`
if [[ ${CHECK_WGET} == 0 ]]
then 
  echo "wget not exist, exit..."
  exit
elif [[ ${CHECK_WGET} == "" ]]
then
  echo "check status empty, plz recheck wget"
  exit
else
  wget --spider  -t3 --timeout=1 ${CHECK_IP}:${CHECK_PORT} 2>/dev/null || STATUS=0
fi


if [[ ${STATUS} == "0" ]]
then 
  echo "${CHECK_IP} at ${CHECK_PORT} fail"
elif [[ ${STATUS} == "" ]]
then
  echo "STATUS empty"
else
  echo "${CHECK_IP} at ${CHECK_PORT} access"
fi
