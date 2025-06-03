# 🔍 故障排除指南

## 🚀 快速诊断命令

```bash
# 检查容器状态
make status

# 查看集群信息
make cluster-info

# 修复集群问题
make fix-cluster

# 查看日志
make logs
```

## 🔍 常见问题

### 🐳 Docker相关问题

#### 问题：容器启动失败
```bash
Error: port is already allocated
```
**解决方案**：
```bash
# 检查端口占用
lsof -i :7000-7005
# 停止占用进程或更改端口配置
make clean && make start
```

#### 问题：镜像拉取失败
```bash
Error: failed to pull image redis:7.4
```
**解决方案**：
```bash
# 手动拉取镜像
docker pull redis:7.4
# 或使用国内镜像源
```

### 🔌 连接问题

#### 问题：集群连接被拒绝
```bash
Connection refused to 127.0.0.1:7000
```
**解决方案**：
```bash
# 检查容器状态
make status
# 查看容器日志
make logs redis-node-0
# 重启集群
make restart
```

#### 问题：集群状态为fail
```bash
cluster_state:fail
cluster_slots_assigned:0
```
**解决方案**：
```bash
# 检查所有节点是否正常
for i in {0..5}; do
    echo "Node $i:"; 
    docker exec redis-node-$i redis-cli -a redis123456 ping
done

# 如果节点正常但集群未创建，手动触发集群创建
docker exec redis-node-0 redis-cli -a redis123456 --cluster create \
    redis-node-0:6379 redis-node-1:6379 redis-node-2:6379 \
    redis-node-3:6379 redis-node-4:6379 redis-node-5:6379 \
    --cluster-replicas 1 --cluster-yes
```

### 🔧 集群创建问题

#### 问题：自动集群创建失败
```bash
Node redis-node-X not ready, waiting...
```
**解决方案**：
```bash
# 等待更长时间让节点完全启动
sleep 30

# 检查节点网络连通性
docker exec redis-node-0 redis-cli -h redis-node-1 -a redis123456 ping

# 重新创建集群
make clean && make start
```

#### 问题：集群配置冲突
```bash
ERR This instance has cluster support disabled
```
**解决方案**：
```bash
# 清理旧的集群配置
make clean
# 重新启动
make start
```

### 📊 性能优化

#### 内存使用优化
```bash
# 在docker-compose.yml中添加内存限制
deploy:
  resources:
    limits:
      memory: 512M
```

#### 网络延迟优化
```bash
# 调整集群超时时间
--cluster-node-timeout 10000
```

### 🔍 诊断命令

#### 检查集群状态
```bash
# 详细集群信息
make cluster-info

# 检查节点连接
docker exec redis-node-0 redis-cli -a redis123456 -c cluster nodes

# 检查槽位分配
docker exec redis-node-0 redis-cli -a redis123456 -c cluster slots
```

#### 日志分析
```bash
# 查看特定节点日志
make logs redis-node-0

# 查看所有日志
make logs

# 实时查看日志
docker-compose logs -f --tail=100
```

### 🔄 恢复操作

#### 重置集群
```bash
# 完全清理并重建
make clean
make start
```

#### 数据恢复
```bash
# 从备份恢复
make backup  # 先备份当前数据
# 将备份文件复制到容器
docker cp backup.rdb redis-node-0:/data/dump.rdb
make restart
```

### 🏥 健康检查

#### 自动健康检查
容器配置了自动健康检查：
```yaml
healthcheck:
  test: ["CMD", "redis-cli", "-a", "redis123456", "ping"]
  interval: 30s
  timeout: 10s
  retries: 5
```

#### 手动健康检查
```bash
# 检查所有节点健康状态
for i in {0..5}; do
    echo "Node $i health:";
    docker inspect redis-node-$i --format='{{.State.Health.Status}}'
done
```

## 📞 获取帮助

如果以上解决方案无法解决问题，请：

1. 收集相关日志：`make logs > debug.log`
2. 记录错误信息和复现步骤
3. 检查系统资源使用情况
4. 提交Issue到项目仓库

### 1. 集群连接和网络问题

#### Redis CLI连接缓慢或I/O错误

**症状：**
- 使用本地`redis-cli`连接集群时出现I/O错误
- 连接响应缓慢或超时
- 特别是在Mac ARM + OrbStack环境中

**原因：**
- Docker端口映射与本地redis-cli的兼容性问题
- OrbStack网络层的特定限制
- IPv6/IPv4双栈配置冲突

**解决方案：**

**方法1：使用项目提供的连接脚本（推荐）**
```bash
# 使用便捷连接命令
make connect

# 或直接运行脚本
./scripts/redis-cli.sh
```

**方法2：手动通过Docker容器连接**
```bash
# 进入Redis容器内部
docker exec -it redis-node-0 redis-cli -c -a redis123456 --no-auth-warning

# 测试集群操作
127.0.0.1:6379> cluster info
127.0.0.1:6379> set test "hello"
127.0.0.1:6379> get test
```

**方法3：检查端口映射**
```bash
# 检查端口是否正确监听
netstat -an | grep 700

# 测试端口连接性
nc -zv localhost 7000
```

#### 集群状态为fail

**症状：**
- `cluster info`显示`cluster_state:fail`
- 尽管所有slots已分配，但集群仍然不可用

**原因：**
- 节点间通信中断
- 集群拓扑信息不一致
- 网络分区导致的状态异常

**解决方案：**
```bash
# 自动修复集群
make fix-cluster

# 手动修复步骤
docker exec -it redis-node-0 redis-cli -a redis123456 --no-auth-warning cluster meet 172.20.0.4 6379
docker exec -it redis-node-0 redis-cli -a redis123456 --no-auth-warning cluster meet 172.20.0.5 6379
# ... 对其他节点重复
```

### 2. 容器和服务问题

#### 容器启动失败

**症状：**
- `docker-compose up`失败
- 容器状态显示为`Exited`

**解决方案：**
```bash
# 检查Docker和Docker Compose
make setup

# 清理并重新启动
make clean
make start

# 查看具体错误
make logs
```

#### 健康检查失败

**症状：**
- 容器状态显示`unhealthy`
- 健康检查持续失败

**解决方案：**
```bash
# 检查Redis进程
docker exec redis-node-0 redis-cli -a redis123456 ping

# 重启特定节点
docker-compose restart redis-node-0

# 完全重建
make clean && make start
```

### 3. 数据和性能问题

#### 数据丢失

**症状：**
- 重启后数据消失
- 集群重新分片后数据不一致

**预防措施：**
```bash
# 定期备份
make backup

# 检查持久化配置
docker exec redis-node-0 redis-cli -a redis123456 config get save
```

#### 性能问题

**症状：**
- 响应时间过长
- 高延迟查询

**诊断命令：**
```bash
# 查看连接数
docker exec redis-node-0 redis-cli -a redis123456 info clients

# 查看内存使用
docker exec redis-node-0 redis-cli -a redis123456 info memory

# 查看慢查询
docker exec redis-node-0 redis-cli -a redis123456 slowlog get
```

### 4. 开发和配置问题

#### 配置文件问题

**症状：**
- 自定义配置不生效
- 集群参数错误

**解决方案：**
```bash
# 验证配置
make validate

# 检查实际配置
docker exec redis-node-0 redis-cli -a redis123456 config get '*'

# 重载配置（部分参数）
docker exec redis-node-0 redis-cli -a redis123456 config rewrite
```

#### 版本兼容性

**症状：**
- 新版本Redis特性不可用
- 客户端连接协议错误

**解决方案：**
- 检查Redis版本：`docker exec redis-node-0 redis-cli -a redis123456 info server`
- 更新客户端库到兼容版本
- 参考官方文档调整配置

## 🆘 紧急恢复

如果集群完全不可用：

```bash
# 1. 完全停止
make stop

# 2. 清理所有数据（注意：会丢失数据）
make clean

# 3. 重新启动
make start

# 4. 验证集群
make test
```

## 📞 获取支持

如果问题仍然存在：

1. 收集诊断信息：
   ```bash
   make status > cluster-status.log
   make logs > cluster-logs.log
   ```

2. 检查系统资源：
   ```bash
   docker system df
   docker system events --since 1h
   ```

3. 查看项目文档：
   - [部署指南](./deployment.md)
   - [架构说明](./architecture.md)
   - [README](../README.md)