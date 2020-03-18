#!/bin/sh
#date 2019-10-16 21:38
#author by hui
#version 0.1
#description:This script is used for frontend updates.

ProNameX=('mstiku.zbgedu.com' 'mtiku.zbgedu.com' 'tiku.zbgedu.com')
ProNameD=('mtikudemo.zbgedu.com' 'mstikudemo.zbgedu.com' 'tikudemo.zbgedu.com')
D244Name=('moocselearning' 'elearning' 'teching' 'tm')
LinShi=('mtikudemot.zbgedu.com' 'tikudemot.zbgedu.com')
Date=`date +%Y%m%d%H%M`
UploadDir=/root/.hui/packages
Demo244=47.96.2.242
Demo245=47.98.213.144
Xianshang=118.31.73.71

Shang_Xian()
{
   read -p "is not update the product env? (y or n)" YoN
   if [ $YoN = "y" ];then
      scp $UploadDir/$PackName* $Xianshang:/root/.hui/packages
      ssh root@$Xianshang "sh -x /root/.hui/front.sh"
   fi
}
for PackName in `ls $UploadDir|awk -F- '{print $1}'`
  do

  if [[ "$PackName" = "elearning" || "$PackName" = "teching" || "$PackName" = "amoocs" || "$PackName" = "tm" ]];then
      scp $UploadDir/$PackName* $Demo244:/root/.hui/packages
      ssh root@$Demo244 "sh -x /root/.hui/front.sh"
  elif [[ ${ProNameX[*]} =~ $PackName ]];then
      scp $UploadDir/$PackName* $Demo245:/root/.hui/packages
      ssh root@$Demo245 "sh -x /root/.hui/front.sh"
#     Shang_Xian
  elif [ "$PackName" = "ilearning" ];then
      scp $UploadDir/$PackName* $Demo244:/root/.hui/packages
      ssh root@$Demo244 "sh -x /root/.hui/front.sh"
#     Shang_Xian
  elif [[ ${LinShi[*]} =~ $PackName ]];then
      scp $UploadDir/$PackName* $Demo245:/root/.hui/packages
      ssh root@$Demo245 "sh -x /root/.hui/front.sh"
  fi
sleep 1
rm -f $UploadDir/$PackName*
done

