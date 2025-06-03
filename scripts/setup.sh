#!/bin/bash

# 🔧 Redis Cluster 环境设置脚本

echo "🔧 Redis Cluster 环境设置"
echo "=========================="

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    exit 1
fi

# 检查Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose未安装，请先安装Docker Compose"
    exit 1
fi

# 检查Orbstack (可选)
if command -v orbctl &> /dev/null; then
    echo "✅ 检测到Orbstack"
else
    echo "⚠️  未检测到Orbstack，确保Docker环境正常运行"
fi

# 检查端口占用
echo "🔍 检查端口占用..."
for port in 7000 7001 7002 7003 7004 7005 17000 17001 17002 17003 17004 17005 5540 9121; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo "⚠️  端口 $port 已被占用"
    fi
done

# 创建必要目录
echo "📁 创建必要目录..."
mkdir -p backups
mkdir -p logs

# 验证Docker Compose配置
echo "✅ 验证配置文件..."
if docker-compose config > /dev/null 2>&1; then
    echo "✅ Docker Compose配置验证通过"
else
    echo "❌ Docker Compose配置有误"
    exit 1
fi

echo ""
echo "🎉 环境设置完成！"
echo "🚀 使用 'make start' 或 './scripts/manage.sh start' 启动集群"