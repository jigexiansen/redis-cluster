# 🔍 故障排除指南

## 常见问题

### 🚀 启动问题

#### 端口占用
```bash
# 检查端口占用
lsof -i :7000-7005
lsof -i :17000-17005

# 释放端口
make clean
```

#### Docker资源不足
```bash
# 清理Docker
docker system prune -f
docker volume prune -f
```

### 🔗 集群问题

#### 集群状态异常
```bash
# 检查集群状态
make status
make cluster-info

# 重置集群
make clean
make start
```

#### 节点连接失败
```bash
# 检查网络
docker network ls
docker network inspect redis-cluster-network

# 重启集群
make restart
```

### 📊 性能问题

#### 内存不足
- 确保每个节点至少1GB内存
- 检查Docker Desktop内存分配

#### 网络延迟高
- 确保节点间延迟低于100ms
- 检查Orbstack配置

## 🔧 调试命令

```bash
# 查看详细日志
make logs

# 进入Redis节点
docker exec -it redis-node-0 redis-cli -a redis123456

# 查看集群配置
docker exec redis-node-0 redis-cli -a redis123456 cluster nodes

# 测试连接
make test
```

## 📞 获取帮助

1. 检查 [Issues](../../issues)
2. 查看 [文档](./README.md)
3. 提交新的Issue