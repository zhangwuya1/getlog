#!/bin/sh
#date 2019-9-20 18:10
#author by hui
#version 0.1
#description:this script is used for educational updates.
CurDir=`pwd`
ProDir=/mnt/tech_project/apache-tomcat-7.0.93-8081-zbes
ComDir=$ProDir/webapps/ROOT/WEB-INF/classes
Date=`date +%Y%m%d%H%M`

PackDir=/home/zh/packages
Dir=com

cd $ComDir
tar zcf $Dir$Date.tar.gz $Dir
cp  /home/zh/packages/com*.zip $ComDir


if [ -d "com.bak" ]
  then
    rm -fr com.bak
fi
mv com com.bak

unzip -q  com*.zip

rm -fr com.bak
cd $Pro_Dir

./bin/shutdown.sh
if [ `ps -ef|grep 8081|grep -v grep|wc -l` -ne 0 ]
       then
         kill -9 `ps -ef|grep 8081|grep -v grep |awk '{print $2}'`
fi
     ./bin/startup.sh && tail -f ./logs/catalina.out
