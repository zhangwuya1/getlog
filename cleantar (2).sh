#!/bin/bash


cd /mnt/mount-project
ls -t teching*.tar.gz |awk '{if(NR>3) print $1}'|xargs -i mv {} /home/zh/packages/
ls -t moocselearning*.tar.gz |awk '{if(NR>3) print $1}'|xargs -i mv {} /home/zh/packages/
ls -t ilearningdemo.zbgedu.com*.tar.gz |awk '{if(NR>3) print $1}'|xargs -i mv {} /home/zh/packages/
ls -t elearning*.tar.gz |awk '{if(NR>3) print $1}'|xargs -i mv {} /home/zh/packages/

cd /home/zh/packages
rm -f *.tar.gz
