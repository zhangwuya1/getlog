#!/bin/sh
#date 2019-9-20 18:08
#author by hui
#version 0.1
#description:This script is used for frontend updates.


Date=`date +%Y%m%d%H%M`
ProDir=/mnt/mount-project

for PackName in `ls /home/zh/packages|awk -F- '{print $1}'`
  do 
  
  cd $ProDir
  if [ "$PackName" = "amoocs" ];then
	ProName=moocslearning
  elif [ "$PackName" = "learning" ];then
	ProName=ilearningdemo.zbgedu.com
  elif [[ "$PackName" = "elearning" || "$PackName" = "teching" ]];then
	ProName=$PackName
  else 
	echo "$PackName is wrong! or the directory is null."
	exit
  fi
  tar zcf $ProName$Date.tar.gz $ProName


  cd  $ProName
  DirMid=`unzip -l /home/zh/packages/${PackName}* |awk '{if(NR==4){print $4}}'`
  Dirzip=${DirMid%%/}
  unzip -q /home/zh/packages/$PackName*

  #  mv $Dirzip  $ProDir/$ProName  
  \cp -r $Dirzip/*  $ProDir/$ProName
  sleep 1
  rm -fr $Dirzip
  rm -f /home/zh/packages/$PackName*
done
