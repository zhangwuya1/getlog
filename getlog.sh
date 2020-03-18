#!/bin/sh
#date 2019-10-23 17:27
#author by hui
#version 0.2
#description:This script is used to get the demo and production environment docker project logs.

ProName=(8301-lms-test-1.0 8302-lms-qti-1.0 8303-lms-user-1.0 8304-lms-mid-1.0)
Date=`date +%H%M%S-%m%d%Y`
HostIp=`hostname -I|awk '{print $1}'`
Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}
Echo_Red()
{
  echo $(Color_Text "$1" "31")
}
Echo_Green()
{
  echo $(Color_Text "$1" "32")
}
Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}
Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}
#-----------------------------------------------------------------------
  read -p "please input your time (hours minute)" HOurs MInute
DanCan()
{
if   [ "$CanS" -eq 1 ];then
    Project=${ProName[0]}
elif [ "$CanS" -eq 2 ];then
    Project=${ProName[1]}
elif [ "$CanS" -eq 3 ];then
    Project=${ProName[2]}
elif [ "$CanS" -eq 4 ];then
    Project=${ProName[3]}
else
  Echo_Red "your input is wrong!please input {1|2|3|4}"
exit
fi
  LogDate=`date +%F`T$HOurs:$MInute:00
  docker logs --since "$LogDate" $Project  > /root/.hui/tikulogs/${Project%%-*}-$Date.log  2>&1
}
  if [ "$#" -eq 1 ];then
	CanS=$1
	DanCan
  else
    for CanS in "$@"
      do
        DanCan
      done
  fi
cd /root/.hui/
tar zcf tikulogs$Date.tar.gz tikulogs



#判断是demo还是线上
  if [ "$HostIp" = "192.168.158.245" ];then
        sz /root/.hui/tikulogs*.tar.gz
    elif [[ "$HostIp" = "172.16.120.157" || "$HostIp" = "172.16.120.158" ]];then
        scp /root/.hui/tikulogs*.tar.gz  root@172.16.120.40:/root/
    else
        echo "your host is wrong."
        exit
  fi
        sleep 2
        rm -f /root/.hui/tikulogs/*  /root/.hui/tikulogs*.tar.gz
