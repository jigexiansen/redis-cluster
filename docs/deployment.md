# 🚀 Redis Cluster部署提示词

## 📋 需求描述

在Mac ARM架构环境下，使用Orbstack创建Redis Cluster：

### 🖥️ 基础环境
- Mac ARM架构（M1/M2/M3等）
- Orbstack已安装并启动
- 目标目录：`/Users/staff/Services/redis-cluster`

### 🏗️ 核心架构要求
1. **🔗 Redis Cluster模式**（非主从复制）
   - 6节点集群：3主3从
   - 数据自动分片到16384个槽位
   - 自动故障转移和负载均衡
   - 端口：7000-7005 + 集群总线端口17000-17005

2. **🐳 镜像选择**
   - 使用Bitnami Redis Cluster镜像：`bitnami/redis-cluster:7.4`
   - 自动集群初始化和管理
   - 生产级配置

3. **🔒 安全配置**
   - 密码认证保护：`redis123456`
   - 数据持久化存储（自动RDB + AOF）
   - 网络隔离和访问控制

### 🛠️ 管理和监控工具
1. **🎯 管理界面**
   - Redis Insight - 端口5540
   - 官方可视化管理工具

2. **📊 监控体系**
   - Redis Exporter监控 - 端口9121
   - 支持Prometheus指标收集
   - 可扩展Grafana仪表板

3. **💻 开发支持**
   - 多语言连接示例（Java、Node.js、Python、Go、C#）
   - 集群模式客户端配置
   - 详细使用文档

### 技术实现要求

#### 1. Docker Compose配置
创建 `docker-compose.yml`：
```yaml
services:
  redis-node-0到redis-node-5:
    image: docker.io/bitnami/redis-cluster:7.4
    environment:
      - REDIS_PASSWORD=redis123456
      - REDIS_NODES=all_nodes
      - REDIS_CLUSTER_CREATOR=yes (仅node-5)
      - REDIS_CLUSTER_REPLICAS=1 (仅node-5)
```

#### 2. 无需手动配置文件
- Bitnami镜像自动处理集群配置
- 通过环境变量管理
- 删除传统的config/目录

#### 3. 增强管理脚本
更新 `manage.sh` 包含：
- cluster-info：显示集群详细信息
- test：集群读写功能测试  
- 支持6节点的备份和监控
- 状态检查功能

#### 4. 更新文档体系
- `README.md` - 集群说明
- `dev-examples.md` - 集群模式连接示例
- `scaling-guide.md` - 集群扩展指南### 关键配置参数
- Redis密码：`redis123456`
- 集群节点：redis-node-0 到 redis-node-5
- 网络名称：`redis-cluster-network`
- 子网：`172.20.0.0/16`
- 数据持久化：自动启用RDB和AOF
- 集群副本数：1（每个主节点1个从节点）

### 端口分配
- 7000-7005：Redis Cluster节点
- 17000-17005：Redis Cluster总线端口
- 5540：Redis Insight管理界面
- 9121：Redis Exporter监控

### 主要特性
- 自动集群初始化（无需手动cluster create）
- 健康检查和自动重启
- 容器间DNS自动发现
- 数据卷持久化存储
- 网络配置优化

### 扩展性设计
- 独立的Redis Cluster服务
- 支持动态添加节点
- 支持升级监控栈（Prometheus + Grafana）
- 与其他服务（如MySQL）完全分离

### 预期产出文件结构
```
RedisCluster/
├── docker-compose.yml        # 集群配置
├── manage.sh                 # 管理脚本
├── README.md                 # 使用说明
├── dev-examples.md          # 集群模式连接示例
├── scaling-guide.md         # 集群扩展指南
└── deployment-prompt.md     # 本部署提示词
```

### 验证标准
1. ✅ 6节点Redis Cluster成功启动
2. ✅ 集群状态健康（cluster info显示ok）
3. ✅ 数据分片正常工作（16384槽位分配）
4. ✅ 故障转移功能正常
5. ✅ Redis Insight可访问和管理
6. ✅ 客户端连接示例可用
7. ✅ 监控指标正常导出
8. ✅ 数据持久化功能正常

### ✨ 方案特点
- 🐳 专业Bitnami镜像，生产级稳定性
- 🔗 分布式Redis Cluster架构
- 🎯 管理工具（Redis Insight）
- 📊 完整可观测性支持（Prometheus）
- ⚙️ 高度自动化，运维简单
- 📈 支持在线动态扩缩容
- 🐳 面向容器化环境
- 🖥️ 适配Mac ARM + Orbstack

**✅ 此方案可直接用于生产环境部署。**