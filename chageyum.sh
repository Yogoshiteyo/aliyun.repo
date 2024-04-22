#!/bin/bash

function chyum(){
    PS3='选择yum源: '
    yum=("aliyun" "backup" "quit")
    select fav in "${yum[@]}"; do
        case $fav in
            "aliyun")
                rm -rf /etc/yum.repos.d/*.repo
                cp /etc/yum.repos.d/aliyun/*.repo /etc/yum.repos.d/
                yum clean all
                yum makecache
                exit
                ;;
            "backup")
                rm -rf /etc/yum.repos.d/*.repo
                cp /etc/yum.repos.d/backup/*.repo /etc/yum.repos.d/
                yum clean all
                yum makecache
                exit
                ;;
        "quit")
                echo "User requested exit"
                exit
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}

if [  ! -d "/etc/yum.repos.d/aliyun"  ];then
        cd /etc/yum.repos.d/
        mkdir backup
        mkdir aliyun
        mv *.repo backup
        curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
        curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
        mv *.repo aliyun
        chyum
    else
        if [  -e "/etc/yum.repos.d/CentOS-Base.repo"  ] && [  ! -e "/etc/yum.repos.d/epel.repo"  ];then
                chyum
            else
                rm -rf /etc/yum.repos.d/aliyun/*.repo
                curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
                curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
                mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/aliyun
                chyum
        fi
fi