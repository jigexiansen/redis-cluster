# 📈 Redis Cluster 扩展指南

基于Bitnami Redis Cluster的扩展方案，适用于Mac ARM + Orbstack环境

## 🔄 添加新集群节点

### 1. 扩展集群节点（推荐）

在`docker-compose.yml`中添加新节点：

```yaml
  # 新的集群节点 6-7
  redis-node-6:
    image: docker.io/bitnami/redis-cluster:7.4
    container_name: redis-node-6
    ports:
      - "7006:6379"
      - "17006:16379"
    volumes:
      - redis-cluster-data-6:/bitnami/redis/data
    environment:
      - REDIS_PASSWORD=redis123456
      - REDIS_NODES=redis-node-0 redis-node-1 redis-node-2 redis-node-3 redis-node-4 redis-node-5 redis-node-6 redis-node-7
      - REDIS_CLUSTER_DYNAMIC_IPS=no
    networks:
      - redis-cluster-network
    restart: unless-stopped

  redis-node-7:
    image: docker.io/bitnami/redis-cluster:7.4
    container_name: redis-node-7
    ports:
      - "7007:6379"
      - "17007:16379"
    volumes:
      - redis-cluster-data-7:/bitnami/redis/data
    environment:
      - REDIS_PASSWORD=redis123456
      - REDIS_NODES=redis-node-0 redis-node-1 redis-node-2 redis-node-3 redis-node-4 redis-node-5 redis-node-6 redis-node-7
      - REDIS_CLUSTER_DYNAMIC_IPS=no
    networks:
      - redis-cluster-network
    restart: unless-stopped

volumes:
  redis-cluster-data-6:
    driver: local
  redis-cluster-data-7:
    driver: local
```

### 2. 动态添加节点到现有集群

```bash
# 1. 启动新节点
docker-compose up -d redis-node-6 redis-node-7

# 2. 将新节点加入集群
docker exec redis-node-0 redis-cli -a redis123456 -c --cluster add-node redis-node-6:6379 redis-node-0:6379

# 3. 重新分配槽位
docker exec redis-node-0 redis-cli -a redis123456 -c --cluster reshard redis-node-0:6379

# 4. 添加从节点
docker exec redis-node-0 redis-cli -a redis123456 -c --cluster add-node redis-node-7:6379 redis-node-0:6379 --cluster-slave
```

## 📊 完整监控栈扩展

### 添加Prometheus + Grafana监控

```yaml
  # Prometheus监控
  prometheus:
    image: prom/prometheus:latest
    container_name: redis-prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    networks:
      - redis-cluster-network
    restart: unless-stopped

  # Grafana可视化
  grafana:
    image: grafana/grafana:latest
    container_name: redis-grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
      - ./monitoring/grafana/dashboards:/var/lib/grafana/dashboards
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin123
      - GF_INSTALL_PLUGINS=redis-datasource
    networks:
      - redis-cluster-network
    restart: unless-stopped

volumes:
  prometheus-data:
    driver: local
  grafana-data:
    driver: local
```### 创建监控配置文件

```bash
# 创建监控目录
mkdir -p monitoring/grafana/dashboards

# Prometheus配置
cat > monitoring/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'redis-exporter'
    static_configs:
      - targets: ['redis-exporter:9121']

  - job_name: 'redis-cluster'
    static_configs:
      - targets: 
        - 'redis-node-0:6379'
        - 'redis-node-1:6379' 
        - 'redis-node-2:6379'
        - 'redis-node-3:6379'
        - 'redis-node-4:6379'
        - 'redis-node-5:6379'
EOF
```

## 🔧 管理脚本扩展

添加到`manage.sh`：

```bash
"scale-up")
    echo "🔼 扩展集群节点..."
    echo "请确认要添加的节点数量（例如：2）:"
    read node_count
    # 实现动态扩展逻辑
    ;;
"monitoring")
    echo "📊 启动完整监控栈..."
    docker-compose up -d prometheus grafana
    echo "Prometheus: http://localhost:9090"
    echo "Grafana: http://localhost:3000"
    ;;
```

## 🚀 性能优化配置

### 高性能Redis Cluster配置

```yaml
  redis-node-0:
    image: docker.io/bitnami/redis-cluster:7.4
    environment:
      - REDIS_PASSWORD=redis123456
      - REDIS_NODES=redis-node-0 redis-node-1 redis-node-2 redis-node-3 redis-node-4 redis-node-5
      - REDIS_CLUSTER_DYNAMIC_IPS=no
      # 性能优化配置
      - REDIS_MAXMEMORY=2gb
      - REDIS_MAXMEMORY_POLICY=allkeys-lru
      - REDIS_IO_THREADS=4
      - REDIS_IO_THREADS_DO_READS=yes
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1'
        reservations:
          memory: 1G
          cpus: '0.5'
```

## 🔐 安全加固

### TLS加密配置

```yaml
  redis-node-0:
    environment:
      - REDIS_TLS_ENABLED=yes
      - REDIS_TLS_PORT=6380
      - REDIS_TLS_CERT_FILE=/certs/redis.crt
      - REDIS_TLS_KEY_FILE=/certs/redis.key
      - REDIS_TLS_CA_FILE=/certs/ca.crt
    volumes:
      - ./certs:/certs:ro
```

## 📋 扩展检查清单

### 扩展前检查
- [ ] 检查当前集群健康状态
- [ ] 确认可用内存和CPU资源
- [ ] 备份现有数据
- [ ] 确认网络端口可用

### 扩展后验证
- [ ] 验证新节点加入集群
- [ ] 检查槽位重新分配
- [ ] 测试数据读写功能
- [ ] 验证故障转移功能
- [ ] 监控系统运行状态

---

💡 **提示**: 扩展操作建议在业务低峰期进行，并做好数据备份。