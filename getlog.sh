#!/bin/sh
#date 2019-9-20 16:17
#author by hui
#version 0.1
#description:This script is used to get the demo and production environment docker project logs.

ProName=(8301-lms-test-1.0 8302-lms-qti-1.0 8303-lms-user-1.0 8304-lms-mid-1.0)
Date=`date +%H%M%S-%m%d%Y`
HostIp=`hostname -I|awk '{print $1}'`

if   [ "$1" -eq 1 ];then
    Project=${ProName[0]}
elif [ "$1" -eq 2 ];then
    Project=${ProName[1]}
elif [ "$1" -eq 3 ];then
    Project=${ProName[2]}
elif [ "$1" -eq 4 ];then
    Project=${ProName[3]}
else
  echo "your input is wrong!please input {1|2|3|4}"
exit
fi

  read -p "please input your time (hours minute)" HOurs MInute

  LogDate=`date +%F`T$HOurs:$MInute:00
  docker logs --since "$LogDate" $Project  > /root/${Project%%-*}-$Date.log  2>1&

#判断是demo还是线上
  if [ "$HostIp" = "192.168.158.245" ];then
        sz /root/${Project%%-*}-$Date.log
    elif [[ "$HostIp" = "172.16.120.157" || "$HostIp" = "172.16.120.158" ]];then
        scp /root/${Project%%-*}-$Date.log root@172.16.120.40:/root/
    else
        echo "your host is wrong."
        exit
  fi
        sleep 2
        rm -f /root/${Project%%-*}-$Date.log
