#!/bin/bash

#echo "🔗 连接到Redis集群..."
#echo "💡 提示：使用 'exit' 退出Redis CLI"
#echo "📝 集群模式已启用，数据会自动路由到正确的节点"
#echo ""

# 进入Redis容器内部的CLI
docker exec -it redis-node-0 redis-cli -c -a redis123456 --no-auth-warning 