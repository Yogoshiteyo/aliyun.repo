#!/bin/bash

function install_docker_repo() {
    read -p "是否安装Docker源？ (y/n): " install_docker
    if [[ $install_docker == "y" || $install_docker == "Y" ]]; then
        curl -o /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    fi
}

function setup_aliyun_repo() {
    local repo_dir="/etc/yum.repos.d/aliyun"

    if [ ! -d "$repo_dir" ] || [ -z "$(ls -A $repo_dir)" ]; then
        echo "未找到阿里云源的文件，确保文件已下载。"
        return 1
    fi

    backup
    echo "现有的YUM源文件已备份到 /etc/yum.repos.d/backup"

    rm -rf /etc/yum.repos.d/*.repo
    cp $repo_dir/*.repo /etc/yum.repos.d/
    yum clean all
    yum makecache
    install_docker_repo
}

function backup() {
    if [ ! -d "/etc/yum.repos.d/backup" ]; then
        mkdir /etc/yum.repos.d/backup
    fi
    mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/
    if [ $? -ne 0 ]; then
        echo "备份失败，请检查权限或路径。"
        return 1
    fi
}



function chyum() {
    PS3='选择操作: '
    options=("阿里云" "恢复备份" "退出")
    select fav in "${options[@]}"; do
        case $fav in
            "阿里云")
                setup_aliyun_repo || continue
                exit
                ;;
            "恢复备份")
                restore_backup || continue
                exit
                ;;
            "退出")
                echo "用户请求退出"
                exit
                ;;
            *)
                echo "无效选项 $REPLY"
                ;;
        esac
    done
}

function download_repo_file() {
    local url=$1
    local output=$2
    local attempts=3

    for ((i=1; i<=attempts; i++)); do
        curl -o $output $url
        if [ -s $output ] && grep -q "baseurl" $output; then
            echo "$output 下载成功"
            return 0
        else
            echo "$output 下载失败，重试 $i/$attempts"
        fi
    done

    echo "$output 下载失败"
    return 1
}

function download_repo_files() {
    mkdir -p /etc/yum.repos.d/aliyun

    download_repo_file https://mirrors.aliyun.com/repo/Centos-7.repo /etc/yum.repos.d/aliyun/CentOS-Base.repo
    download_repo_file https://mirrors.aliyun.com/repo/epel-7.repo /etc/yum.repos.d/aliyun/epel.repo
}

if [ ! -d "/etc/yum.repos.d/aliyun" ]; then
    download_repo_files
fi

chyum
