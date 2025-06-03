# 🏗️ Redis Cluster 架构说明

## 🔗 集群架构

Redis Cluster自动将数据分片到16384个槽位，在6个节点间分布：

- **3个主节点** (7000, 7001, 7002) - 负责数据写入和分片
- **3个从节点** (7003, 7004, 7005) - 提供高可用和读取分流

## ✨ 核心优势

- 📊 **数据分片** - 16384个槽位自动分配
- 🛡️ **故障转移** - 主节点宕机时从节点自动接管  
- ⚖️ **负载均衡** - 读写请求智能路由
- 📈 **在线扩容** - 支持动态添加/删除节点
- 🔒 **强一致性** - 分布式一致性保证

## 🔧 技术栈

### 🐳 Redis镜像选择
- **镜像**: redis:7.4 (官方镜像)
- **优势**: 稳定可靠，社区支持好，无第三方依赖
- **配置**: 启用集群模式，独立节点启动

### 🚀 集群创建策略
- **方式**: 独立节点 + 自动集群创建
- **流程**: 先启动独立节点，再自动检测并创建集群
- **好处**: 避免第三方镜像的兼容性问题

### 🌐 网络配置
- **网络**: redis-cluster-network (172.20.0.0/16)
- **服务发现**: 容器间DNS自动解析
- **端口映射**: 7000-7005 + 集群总线17000-17005

## 🎯 组件说明

### Redis Cluster节点
6个Redis实例独立启动，配置集群模式：
```yaml
command: >
  redis-server 
  --cluster-enabled yes
  --cluster-config-file nodes.conf
  --cluster-node-timeout 5000
  --appendonly yes
  --requirepass redis123456
  --masterauth redis123456
  --protected-mode no
```

### 自动集群创建
启动脚本自动检测并创建集群：
```bash
# 检查集群状态
cluster_state=$(docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null | grep "cluster_state:ok" || echo "")

# 如果没有集群，自动创建
if [ -z "$cluster_state" ]; then
    docker exec redis-node-0 redis-cli -a redis123456 --cluster create \
        redis-node-0:6379 redis-node-1:6379 redis-node-2:6379 \
        redis-node-3:6379 redis-node-4:6379 redis-node-5:6379 \
        --cluster-replicas 1 --cluster-yes
fi
```

### Redis Insight
官方Web管理界面，提供集群监控和管理功能

### Redis Exporter  
Prometheus指标导出器，用于监控集群状态和性能

## 🔍 数据流

1. **写入请求** → 自动路由到对应槽位的主节点
2. **读取请求** → 可从主节点或从节点读取
3. **故障检测** → 集群自动检测节点状态
4. **故障转移** → 从节点自动提升为主节点

## 📊 槽位分配

- 槽位0-5460: redis-node-0 (主) ↔ redis-node-3 (从)
- 槽位5461-10922: redis-node-1 (主) ↔ redis-node-4 (从)  
- 槽位10923-16383: redis-node-2 (主) ↔ redis-node-5 (从)

## 🔄 部署流程

1. **启动容器**: 6个Redis节点独立启动
2. **等待就绪**: 所有节点启动完成并通过健康检查
3. **检测集群**: 自动检查是否已存在集群配置
4. **创建集群**: 如无集群，执行集群创建命令
5. **验证状态**: 确认集群状态为`cluster_state:ok`

## 🛡️ 安全特性

- **密码认证**: 统一密码保护所有节点
- **网络隔离**: 专用Docker网络，容器间通信
- **数据持久化**: AOF + RDB双重备份
- **健康检查**: 自动监控节点状态