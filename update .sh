#!/bin/sh
#date 2019-9-21
#author by hui
#version 1.0
#description :this is a  script to update the code.
CurDir=`pwd`
Date=`date +%Y%m%d%H%M`
PackDir=/root/.hui/packages
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
##################################################################################################################
if [ ! -s $PackDir ];then
	Echo_Red "the packages directory does not exist！"
    elif [ `ls $PackDir|wc -l` = 0 ];then
	Echo_Red "please upload your file ."
    else
	for PackName in `ls $PackDir|awk -F_ '{print $1}'`  
	    do
#		cd $CurDir

		awk  '$1~/^('$PackName')$/{print $1,$2,$3}' "$CurDir/serverlist.txt">/root/tmp.txt
#		cat serverlist.txt | awk -v name="$PackName" ' $0 ~ name {print $0}'>/root/tmp.txt
		read ProName PortNum ProDir < /root/tmp.txt
        	Echo_Green "############################################"
        	Echo_Green "############the $ProName start##############"
        	Echo_Green "############################################"

		rm -f /root/tmp.txt
		if [ "$?" -eq 0 ]
	            then
#############################################################################Root_Dir
			Echo_Blue "备份打包root目录。。。"
			if [ -f $ProDir/conf/Catalina/localhost/ROOT.xml ];then
		            MidDir=`head $ProDir/conf/Catalina/localhost/ROOT.xml|awk -F'"' '{if(NR==2){print $4}}'`
		            RootDir=`dirname $MidDir`
		        else
		            RootDir=$ProDir/webapps
			fi
#############################################################################打包备份root目录
			cd $RootDir
			if [ -d ROOT ];then
			        RootName=ROOT
			elif [ -d ROOTW ];then
			        RootName=ROOTW
			else
			        exit
			        Echo_Red "the ROOT directory is not found."
			fi
			#####备份
			tar zcf $RootName$Date.tar.gz $RootName
			###删除多于3个的备份
			ls -t ROOT*.tar.gz |awk '{if(NR>3) print $1}'|xargs rm -f
#################################################################################停止项目。。。
                        Echo_Blue "停止项目运行。。。"
			cd $ProDir && ./bin/shutdown.sh
			if [ `ps -ef|grep $PortNum|grep -v grep|wc -l` -ne 0 ]
			        then
			            kill -9 `ps -ef|grep $PortNum|grep -v grep |awk '{print $2}'`
			fi
			#清空日志
			Echo_Blue "清空日志。。。"
			>$ProDir/logs/catalina.out
############################################################################升级。。。
			Echo_Blue "更新中。。。"
			mkdir -p /root/.hui/$PackName && tar xf $PackDir/$PackName*.tar.gz -C /root/.hui/$PackName --strip-components 1
			\cp  -r /root/.hui/$PackName/*  $RootDir/$RootName/
			if [ $? -eq 0 ]	
			    then
		            rm -fr /root/.hui/$PackName
		          	rm -f $PackDir/$PackName*
			fi
############################################################################启动项目。。。
			Echo_Blue "启动项目。。。"
			./bin/startup.sh 
			#判断项目是否启动
			for ((i=1;i<=11;++i))
			do
				sleep 3 
				if [ `grep "Server startup" $ProDir/logs/catalina.out|wc -l ` -eq 1 ];then
				grep "Server startup" $ProDir/logs/catalina.out
					if [ $? -eq 0 ];then
		                Echo_Yellow "SECCESS!!!"
                	else
                    	Echo_Yellow "FALSE!!!"
                    fi
				break
				fi
			done
		    sleep 1 
		fi
		cd $CurDir
	    done
fi   
