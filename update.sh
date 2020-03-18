#!/bin/sh
#date 2019-9-21
#author by hui
#version 1.0
#description :this is a  script to update the code.
CurDir=`pwd`
Date=`date +%Y%m%d%H%M`
PackDir=/home/zh/packages
##################################################################################################################
if [ ! -s $PackDir ];then
	echo "the packages directory does not exist！"
    elif [ `ls $PackDir|wc -l` = 0 ];then
	echo "please upload your file ."
    else
	for PackName in `ls $PackDir|awk -F_ '{print $1}'`  
	    do
		cd $CurDir
		awk  '$1~/^('$PackName')$/{print $1,$2,$3}' "$CurDir/serverlist.txt">/root/tmp.txt
#		cat serverlist.txt | awk -v name="$PackName" ' $0 ~ name {print $0}'>/root/tmp.txt
		read ProName PortNum ProDir < /root/tmp.txt
		rm -f /root/tmp.txt
		if [ "$?" -eq 0 ]
	            then
#############################################################################Root_Dir
			if [ -f $ProDir/conf/Catalina/localhost/ROOT.xml ];then
		            MidDir=`head $ProDir/conf/Catalina/localhost/ROOT.xml|awk -F'"' '{if(NR==2){print $4}}'`
		            RootDir=`dirname $MidDir`
		        else
		            RootDir=$ProDir/webapps
			fi
#############################################################################Tar_Root
			cd $RootDir
			if [ -d ROOT ];then
			        RootName=ROOT
			elif [ -d ROOTW ];then
			        RootName=ROOTW
			else
			        exit
			        echo "the ROOT directory is not found."
			fi
			tar zcf $RootName$Date.tar.gz $RootName
############################################################################Update_Pr
cd $ProDir && ./bin/shutdown.sh
			if [ `ps -ef|grep $PortNum|grep -v grep|wc -l` -ne 0 ]
			        then
			            kill -9 `ps -ef|grep $PortNum|grep -v grep |awk '{print $2}'`
			fi

			mkdir -p /home/zh/$PackName && tar xf $PackDir/$PackName*.tar.gz -C /home/zh/$PackName --strip-components 1
			\cp  -r /home/zh/$PackName/*  $RootDir/$RootName/
			if [ $? -eq 0 ]	
			       then
		            	  rm -fr /home/zh/$PackName
		          	  rm -f $PackDir/$PackName*
			fi
############################################################################Shut_Start
			
			./bin/startup.sh && tail -f ./logs/catalina.out >/root/.hui/$PackName.log 2>1&
		    sleep 2
		fi

	    done
fi   
