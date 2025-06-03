#!/bin/bash

# 🚀 Redis Cluster管理脚本
# 🖥️ 适用于Mac ARM + Orbstack环境

# 切换到项目根目录
cd "$(dirname "$0")/.."

case "$1" in
    "start")
        echo "🚀 启动Redis Cluster（6节点，3主3从）..."
        docker-compose up -d
        echo "⏳ 等待节点启动完成..."
        sleep 15
        
        # 检查是否已经有集群
        cluster_state=$(docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null | grep "cluster_state:ok" || echo "")
        
        if [ -z "$cluster_state" ]; then
            echo "🔧 自动创建Redis集群..."
            echo "🔗 创建集群：6节点(3主3从)..."
            docker exec redis-node-0 redis-cli -a redis123456 --cluster create \
                redis-node-0:6379 redis-node-1:6379 redis-node-2:6379 \
                redis-node-3:6379 redis-node-4:6379 redis-node-5:6379 \
                --cluster-replicas 1 --cluster-yes
            echo ""
            echo "⏳ 等待集群初始化完成..."
            sleep 10
        else
            echo "ℹ️ 集群已存在，跳过创建步骤"
        fi
        
        # 验证集群状态并自动修复
        echo "🔍 验证集群状态..."
        retry_count=0
        max_retries=3
        
        while [ $retry_count -lt $max_retries ]; do
            cluster_status=$(docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null | grep "cluster_state:" | cut -d: -f2 | tr -d '\n\r ')
            
            if [ "$cluster_status" = "ok" ]; then
                echo "✅ 集群状态正常：cluster_state:ok"
                break
            elif [ "$cluster_status" = "fail" ]; then
                echo "⚠️ 检测到集群状态异常：cluster_state:fail"
                echo "🔧 自动修复集群连接..."
                
                # 强制所有节点重新meet
                for i in {1..5}; do
                    docker exec redis-node-0 redis-cli -a redis123456 -c cluster meet 172.20.0.$((i+1)) 6379 2>/dev/null >/dev/null
                done
                
                echo "⏳ 等待集群重新同步..."
                sleep 15
                retry_count=$((retry_count + 1))
                echo "🔄 重试验证 ($retry_count/$max_retries)..."
            else
                echo "❌ 无法获取集群状态，正在重试... (当前值: '$cluster_status')"
                sleep 5
                retry_count=$((retry_count + 1))
            fi
        done
        
        # 最终状态检查
        final_status=$(docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null | grep "cluster_state:" | cut -d: -f2 | tr -d '\n\r ')
        if [ "$final_status" = "ok" ]; then
            echo ""
            echo "🎉 Redis Cluster启动成功！"
            echo "📊 检查集群状态:"
            docker-compose ps
            echo ""
            echo "🔍 集群信息摘要:"
            docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null | grep -E "cluster_state|cluster_slots_assigned|cluster_known_nodes|cluster_size"
        else
            echo ""
            echo "❌ 集群启动失败，状态：'$final_status'"
            echo "💡 建议手动排查："
            echo "   1. make logs - 查看日志"
            echo "   2. make cluster-info - 查看详细状态"
            echo "   3. make clean && make start - 重新部署"
            exit 1
        fi
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
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster nodes 2>/dev/null
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
            docker exec redis-node-0 redis-cli -a redis123456 -c set "test:key:$i" "value$i" 2>/dev/null
        done
        echo ""
        echo "📖 读取测试数据:"
        for i in {1..5}; do
            result=$(docker exec redis-node-0 redis-cli -a redis123456 -c get "test:key:$i" 2>/dev/null)
            echo "test:key:$i = $result"
        done
        ;;
    "cluster-info")
        echo "🔍 详细集群信息:"
        echo "集群状态:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null
        echo ""
        echo "节点信息:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster nodes 2>/dev/null
        echo ""
        echo "插槽分布:"
        docker exec redis-node-0 redis-cli -a redis123456 -c cluster slots 2>/dev/null
        ;;
    "fix-cluster")
        echo "🔧 修复集群连接问题..."
        echo "强制节点重新发现..."
        for i in {1..5}; do
            echo "重连节点 $i..."
            docker exec redis-node-0 redis-cli -a redis123456 -c cluster meet 172.20.0.$((i+1)) 6379 2>/dev/null
        done
        echo "等待集群同步..."
        sleep 15
        cluster_status=$(docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null | grep "cluster_state:" | cut -d: -f2)
        echo "修复后状态：cluster_state:$cluster_status"
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
            docker exec redis-node-$i redis-cli -a redis123456 BGSAVE 2>/dev/null
        done
        sleep 10
        for i in {0..5}; do
            docker cp redis-node-$i:/data/dump.rdb "backups/redis_node_${i}_backup_${timestamp}.rdb"
        done
        echo "✅ 备份完成: backups/redis_*_backup_${timestamp}.rdb"
        ;;
    *)
        echo "🚀 Redis Cluster 管理工具"
        echo ""
        echo "用法: $0 {start|stop|restart|status|logs|test|cluster-info|fix-cluster|clean|backup}"
        echo ""
        echo "📋 命令说明:"
        echo "  🚀 start        - 启动Redis Cluster并自动创建/修复集群"
        echo "  ⏹️ stop         - 停止Redis Cluster"
        echo "  🔄 restart      - 重启Redis Cluster"
        echo "  📊 status       - 查看集群状态和节点信息"
        echo "  📝 logs         - 查看日志 (可指定服务名)"
        echo "  🧪 test         - 测试集群读写功能"
        echo "  🔍 cluster-info - 显示详细集群信息"
        echo "  🔧 fix-cluster  - 修复集群连接问题"
        echo "  🧹 clean        - 清理数据和容器"
        echo "  💾 backup       - 备份所有节点数据"
        echo ""
        echo "🌐 访问地址:"
        echo "  🔗 Redis Cluster: localhost:7000-7005"
        echo "  🎯 Redis Insight: http://localhost:5540"
        echo "  📊 监控指标:      http://localhost:9121"
        ;;
esac