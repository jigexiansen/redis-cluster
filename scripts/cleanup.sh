#!/bin/bash

# 🧹 Redis Cluster 清理脚本

echo "🧹 Redis Cluster 清理工具"
echo "========================="

# 停止所有容器
echo "⏹️ 停止Redis Cluster..."
docker-compose down

# 清理容器
echo "🗑️ 清理容器..."
docker-compose down --volumes --remove-orphans

# 清理镜像 (可选)
read -p "🤔 是否清理Redis镜像? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️ 清理Redis镜像..."
    docker images | grep redis | awk '{print $3}' | xargs -r docker rmi
fi

# 清理网络
echo "🌐 清理网络..."
docker network prune -f

# 清理卷
echo "💾 清理数据卷..."
docker volume prune -f

# 清理系统
echo "🧹 清理Docker系统..."
docker system prune -f

# 清理备份文件 (可选)
if [ -d "backups" ] && [ "$(ls -A backups)" ]; then
    read -p "🤔 是否清理备份文件? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️ 清理备份文件..."
        rm -rf backups/*
    fi
fi

echo ""
echo "✅ 清理完成！"
echo "🚀 使用 'make start' 重新启动集群"