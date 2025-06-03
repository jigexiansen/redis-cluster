# 📖 Redis Cluster 部署指南

## 🎯 部署概述

本项目提供基于官方Redis镜像的高可用Redis集群解决方案，采用**独立节点启动 + 自动集群创建**的方式，确保部署稳定可靠。

## 🏗️ 架构说明

### 📦 技术栈
- **Redis版本**: 7.4 (官方镜像)
- **容器编排**: Docker Compose
- **网络**: 自定义bridge网络
- **数据持久化**: Docker卷 + AOF/RDB

### 🔧 集群配置
- **节点数量**: 6个（3主3从）
- **数据分片**: 16384个槽位
- **故障转移**: 自动
- **密码认证**: 启用

## 🚀 快速部署

### 1. 环境准备

#### 系统要求
- **操作系统**: macOS ARM (推荐) 或 Linux/Windows
- **内存**: 最少4GB可用内存
- **硬盘**: 最少10GB可用空间

#### 软件依赖
```bash
# 检查Docker版本
docker --version  # 需要 20.10+

# 检查Docker Compose版本  
docker-compose --version  # 需要 V2

# 检查端口占用
lsof -i :7000-7005
lsof -i :17000-17005
lsof -i :5540,9121
```

### 2. 获取项目

```bash
# 克隆项目
git clone https://github.com/jigexiansen/redis-cluster.git
cd redis-cluster

# 检查环境
make setup
```

### 3. 一键部署

```bash
# 启动集群（包含自动创建集群）
make start
```

### 4. 验证部署

```bash
# 检查集群状态
make status

# 查看详细信息
make cluster-info

# 测试集群功能
make test
```

## 🔧 详细部署流程

### 阶段1: 容器启动
```bash
# Docker Compose启动6个Redis节点
docker-compose up -d

# 每个节点配置：
# - 独立Redis实例
# - 启用集群模式
# - 密码认证
# - 数据持久化
```

### 阶段2: 等待就绪
```bash
# 等待所有节点完全启动
sleep 15

# 健康检查确认节点状态
# healthcheck: redis-cli ping
```

### 阶段3: 集群检测
```bash
# 检查是否已有集群配置
cluster_state=$(docker exec redis-node-0 redis-cli -a redis123456 -c cluster info 2>/dev/null | grep "cluster_state:ok")
```

### 阶段4: 自动创建集群
```bash
# 如果无集群，自动创建
if [ -z "$cluster_state" ]; then
    docker exec redis-node-0 redis-cli -a redis123456 --cluster create \
        redis-node-0:6379 redis-node-1:6379 redis-node-2:6379 \
        redis-node-3:6379 redis-node-4:6379 redis-node-5:6379 \
        --cluster-replicas 1 --cluster-yes
fi
```

### 阶段5: 状态验证
```bash
# 确认集群状态正常
# cluster_state:ok
# cluster_slots_assigned:16384
# cluster_known_nodes:6
```

## 📊 监控和管理

### Web管理界面
- **Redis Insight**: http://localhost:5540
- **功能**: 可视化集群状态、数据浏览、性能监控

### 指标监控
- **Redis Exporter**: http://localhost:9121
- **Prometheus指标**: 集群状态、性能指标、节点健康

### 命令行管理
```bash
# 查看集群状态
make status

# 实时日志
make logs

# 性能测试
make test

# 数据备份
make backup
```

## 🔒 安全配置

### 网络安全
- **隔离网络**: 专用Docker网络`redis-cluster-network`
- **端口映射**: 仅必要端口对外暴露
- **防火墙**: 建议配置防火墙规则

### 认证授权
- **密码保护**: 统一密码`redis123456`（生产环境请修改）
- **访问控制**: 容器间通信限制

### 数据安全
- **数据持久化**: AOF + RDB双重保障
- **定期备份**: 自动备份脚本
- **加密传输**: 支持TLS（可选配置）

## 🎛️ 配置定制

### 修改密码
```yaml
# docker-compose.yml
command: >
  redis-server 
  --requirepass YOUR_PASSWORD
  --masterauth YOUR_PASSWORD
```

### 调整内存
```yaml
# docker-compose.yml
deploy:
  resources:
    limits:
      memory: 1G
```

### 修改端口
```yaml
# docker-compose.yml
ports:
  - "YOUR_PORT:6379"
```

## 🔄 升级和维护

### 滚动升级
```bash
# 停止集群
make stop

# 拉取新镜像
docker pull redis:7.4

# 重新启动
make start
```

### 数据迁移
```bash
# 备份数据
make backup

# 迁移到新环境
# 1. 部署新集群
# 2. 恢复数据备份
# 3. 验证数据完整性
```

### 扩容缩容
```bash
# 添加节点（需要修改配置）
# 1. 更新docker-compose.yml
# 2. 启动新节点
# 3. 加入集群
# 4. 重新分配槽位
```

## 🚨 故障排除

详细的故障排除指南请参考 [troubleshooting.md](troubleshooting.md)

### 常见问题
- **端口冲突**: 检查端口占用
- **内存不足**: 增加Docker内存限制
- **集群创建失败**: 检查节点网络连通性
- **数据丢失**: 恢复备份数据

## 📞 技术支持

- 📖 [项目文档](../README.md)
- 🐛 [问题反馈](https://github.com/jigexiansen/redis-cluster/issues)
- 💬 [讨论区](https://github.com/jigexiansen/redis-cluster/discussions)