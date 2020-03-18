#!/bin/sh
#date 2019-9-20 18:10
#author by hui
#version 0.1
#description:this script is used for educational updates.
CurDir=`pwd`
ProDir=/mnt/tech_project/apache-tomcat-7.0.93-8081-zbes
ComDir=$ProDir/webapps/ROOT/WEB-INF/classes/com
Date=`date +%Y%m%d%H%M`

PackDir=/root/.hui/packages
#关闭项目
cd $ProDir
./bin/shutdown.sh
if [ `ps -ef|grep 8081|grep -v grep|wc -l` -ne 0 ]
       then
         kill -9 `ps -ef|grep 8081|grep -v grep |awk '{print $2}'`
fi

#清空日志
Echo_Blue "清空日志。。。"
>$ProDir/logs/catalina.out

#打包root目录
cd $ProDir/webapps
tar zcf ROOT${Date}.tar.gz ROOT

###删除多于3个的备份
ls -t ROOT*.tar.gz |awk '{if(NR>3) print $1}'|xargs rm

#替换com包
cd $ComDir

cp $PackDir/edu*.zip $ComDir   && rm -fr edu/ && unzip -q  edu*.zip && rm -f edu*.zip

#启动项目
cd $ProDir

     ./bin/startup.sh 

###判断是否启动
     for ((i=1;i<=35;++i))
     do
     	sleep 1
	echo $i
     	if [ `grep "INFO: Server startup" $ProDir/logs/catalina.out|wc -l ` -eq 1 ];then
     	grep "INFO: Server startup" $ProDir/logs/catalina.out
     	if [ $? -eq 0 ];then
     		echo "SECCESS!!!"
	rm -f $PackDir/edu*.zip
     	else
     		echo "FALSE!!!"
     	fi
     	break
     fi
     done
