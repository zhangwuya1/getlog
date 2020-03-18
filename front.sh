#!/bin/sh
#date 2019-10-16 21:32
#author by hui
#version 0.2
#description:This script is used for frontend updates.

CurDir=`pwd`
Date=`date +%Y%m%d%H%M`
XianName=('tiku.zbgedu.com' 'mtiku.zbgedu.com' 'mstiku.zbgedu.com')
D245Name=('tikudemot.zbgedu.com' 'mtikudemo.zbgedu.com' 'mstikudemo.zbgedu.com')
D244Name=('moocselearning' 'elearning' 'teching' 'teacherManage')

#确认主机和项目目录
HostMa=`hostname -I|awk '{print $1}'`

if [ "$HostMa" = "192.168.158.244" ];then
#if [ "$HostMa" = "172.16.1.192" ];then
    ProDir=/mnt/mount-project
    HostNa=D244
 elif [ "$HostMa" = "192.168.158.245" ];then
#elif [ "$HostMa" = "172.16.1.187" ];then
   ProDir=/mnt/mount-project
   HostNa=D245
 elif [ "$HostMa" = "172.16.120.40" ];then
#elif [ "$HostMa" = "172.16.1.189" ];then
   ProDir=/mnt/mount-staticfile
   HostNa=Xian
fi

for PackName in `ls /root/.hui/packages|awk -F- '{print $1}'`
  do 
#确定项目文件夹
case "${PackName}" in
amoocs)
    echo "the proname is ${D244Name[0]}"
    ProName=${D244Name[0]}
    ;;
elearning)
    echo "the proname is ${D244Name[1]}"
    ProName=${D244Name[1]}
    ;;
teching)
    echo "the proname is ${D244Name[2]}"
    ProName=${D244Name[2]}
    ;;
tm)
    echo "the proname is ${D244Name[3]}"
    ProName=${D244Name[3]}
    ;;
ilearning)
    echo "the proname is ilearning.zbgedu.com"
    if [ "$HostNa" = "D244" ];then
       ProName="ilearningdemo.zbgedu.com" 
    elif [ "$HostNa" = "Xian" ];then
       ProName="ilearning.zbgedu.com"
    fi
    ;;
tiku.zbgedu.com)
    echo "the proname is ${XianName[0]}"
    if [ "$HostNa" = "D245" ];then
       ProName=${D245Name[0]} 
    elif [ "$HostNa" = "Xian" ];then
       ProName=${XianName[0]} 
    fi
    ;;
mtiku.zbgedu.com)
    echo "the proname is ${XianName[1]}"
    if [ "$HostNa" = "D245" ];then
       ProName=${D245Name[1]} 
    elif [ "$HostNa" = "Xian" ];then
       ProName=${XianName[1]} 
    fi
    ;;
mstiku.zbgedu.com)
    echo "the proname is ${XianName[2]}"
    if [ "$HostNa" = "D245" ];then
       ProName=${D245Name[2]} 
    elif [ "$HostNa" = "Xian" ];then
       ProName=${XianName[2]} 
    fi
    ;;
*)
    echo "$PackName is wrong! or the directory is null."
    exit
esac
  
#进入目录打包备份
cd $ProDir
tar zcf $ProName$Date.tar.gz $ProName

##进入项目 更新项目文件
  cd  $ProName
  DirMid=`unzip -l /root/.hui/packages/${PackName}* |awk '{if(NR==4){print $4}}'`
  Dirzip=${DirMid%%/}
  unzip -q /root/.hui/packages/$PackName*

  \cp -r $Dirzip/*  $ProDir/$ProName

##删除压缩包和解压文件夹
  sleep 1
  rm -fr $Dirzip
  rm -f /root/.hui/packages/$PackName*
##回到初始目录
  cd $CurDir

done
