# OpenEuler_清华大学软件源
## 一键换源脚本

```bash
#!/bin/bash

if [  ! -d "/etc/yum.repos.d/tuna.repo-main"  ];then
		cd /etc/yum.repos.d/
        mkdir backup
        mv *.repo backup
        wget https://github.com/Yogoshiteyo/tuna.repo/archive/refs/heads/main.zip
        unzip main.zip
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
