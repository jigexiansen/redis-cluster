#!/bin/bash

# 🚀 Redis Cluster管理脚本
# 🖥️ 适用于Mac ARM + Orbstack环境

# 切换到项目根目录
cd "$(dirname "$0")/.."

case "$1" in
    "start")
        echo "🚀 启动Redis Cluster（6节点，3主3从）..."
        docker-compose up -d
        echo "⏳ 等待集群初始化..."
        sleep 30
        echo "📊 检查集群状态:"
        docker-compose ps
        echo ""
        echo "🔍 验证集群信息:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster info
        ;;
    "stop")
        echo "⏹️ 停止Redis Cluster..."
        docker-compose down
        ;;
    "restart")
        echo "🔄 重启Redis Cluster..."
        docker-compose restart
        ;;
    "status")
        echo "📊 Redis Cluster状态:"
        docker-compose ps
        echo ""
        echo "🔗 集群节点信息:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster nodes
        ;;
    "logs")
        if [ -z "$2" ]; then
            docker-compose logs -f
        else
            docker-compose logs -f "$2"
        fi
        ;;
    "test")
        echo "🧪 测试Redis Cluster连接..."
        echo "📝 写入测试数据到集群:"
        for i in {1..10}; do
            docker exec redis-node-0 redis-cli -a redis123456 -c set "test:key:$i" "value$i"
        done
        echo ""
        echo "📖 读取测试数据:"
        for i in {1..5}; do
            result=$(docker exec redis-node-0 redis-cli -a redis123456 -c get "test:key:$i")
            echo "test:key:$i = $result"
        done
        ;;
    "cluster-info")
        echo "🔍 详细集群信息:"
        echo "集群状态:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster info
        echo ""
        echo "节点信息:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster nodes
        echo ""
        echo "插槽分布:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster slots
        ;;
    "clean")
        echo "🧹 清理Redis Cluster数据和容器..."
        docker-compose down -v
        docker system prune -f
        ;;
    "backup")
        echo "💾 备份Redis Cluster数据..."
        timestamp=$(date +%Y%m%d_%H%M%S)
        mkdir -p backups
        for i in {0..5}; do
            echo "备份节点 redis-node-$i..."
            docker exec redis-node-$i redis-cli -a redis123456 BGSAVE
        done
        sleep 10
        for i in {0..5}; do
            docker cp redis-node-$i:/bitnami/redis/data/dump.rdb "backups/redis_node_${i}_backup_${timestamp}.rdb"
        done
        echo "✅ 备份完成: backups/redis_*_backup_${timestamp}.rdb"
        ;;
    *)
        echo "🚀 Redis Cluster 管理工具"
        echo ""
        echo "用法: $0 {start|stop|restart|status|logs|test|cluster-info|clean|backup}"
        echo ""
        echo "📋 命令说明:"
        echo "  🚀 start        - 启动Redis Cluster (6节点)"
        echo "  ⏹️ stop         - 停止Redis Cluster"
        echo "  🔄 restart      - 重启Redis Cluster"
        echo "  📊 status       - 查看集群状态和节点信息"
        echo "  📝 logs         - 查看日志 (可指定服务名)"
        echo "  🧪 test         - 测试集群读写功能"
        echo "  🔍 cluster-info - 显示详细集群信息"
        echo "  🧹 clean        - 清理数据和容器"
        echo "  💾 backup       - 备份所有节点数据"
        echo ""
        echo "🌐 访问地址:"
        echo "  🔗 Redis Cluster: localhost:7000-7005"
        echo "  🎯 Redis Insight: http://localhost:5540"
        echo "  📊 监控指标:      http://localhost:9121"
        ;;
esac