# OpenEuler_清华大学软件源
## 一键换源脚本

```bash
#!/bin/bash

if [  ! -d "/etc/yum.repos.d/tuna.repo-main"  ];then		#判断是否存在/etc/yum.repos.d/tuna.repo-main目录
	cd /etc/yum.repos.d/					#不存在则进入/etc/yum.repos.d目录建立相关文件夹，如存在则说明运行过此脚本，可直接执行选择yum源
        mkdir backup						#创建backup目录
        mv *.repo backup					#将原来的repo文件备份
        wget https://github.com/Yogoshiteyo/tuna.repo/archive/refs/heads/main.zip
								#下载新的repo文件
        unzip main.zip						#将新的repo文件解压到/etc/yum.repos.d目录，得到tuna.repo-main目录，新的repo文件便在此目录中
        PS3='选择yum源: '						#开始选择yum源
        yum=("tuna" "backup" "Quit")				#tuna为清华大学软件源，backup为之前备份的软件源
        select fav in "${yum[@]}"; do
            case $fav in
                "tuna")
                    rm -rf /etc/yum.repos.d/*.repo		#删除/etc/yum.repos.d目录下所有repo文件
                    cp /etc/yum.repos.d/tuna.repo-main/*.repo /etc/yum.repos.d/
		    						#将/etc/yum.repos.d/tuna.repo-main目录中的tuna.repo文件拷贝至/etc/yum.repos.d目录
                    yum clean all				#清除yum缓存
                    yum makecache				#重新建立yum缓存
                    exit
                    ;;
                "backup")
                    rm -rf /etc/yum.repos.d/*.repo
                    cp /etc/yum.repos.d/backup/*.repo /etc/yum.repos.d/
                    yum clean all
                    yum makecache
                exit
                    ;;
            "Quit")
                echo "User requested exit"
                exit
                ;;
                *) echo "invalid option $REPLY";;
            esac
        done
	else
		PS3='选择yum源: '
        yum=("tuna" "backup" "Quit")
        select fav in "${yum[@]}"; do
            case $fav in
                "tuna")
                    rm -rf /etc/yum.repos.d/*.repo
                    cp /etc/yum.repos.d/tuna.repo-main/*.repo /etc/yum.repos.d/
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
            "Quit")
                echo "User requested exit"
                exit
                ;;
                *) echo "invalid option $REPLY";;
            esac
        done
fi
```
