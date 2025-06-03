# 🐍 Python Redis Cluster 示例

## 安装依赖

```bash
pip install -r requirements.txt
```

## 🚀 运行示例

```bash
# 直接运行
python redis_cluster_example.py

# 或使用Python3
python3 redis_cluster_example.py
```

## 基本配置

```python
from redis.cluster import RedisCluster

# 集群连接配置
startup_nodes = [
    {"host": "localhost", "port": 7000},
    {"host": "localhost", "port": 7001},
    {"host": "localhost", "port": 7002},
    {"host": "localhost", "port": 7003},
    {"host": "localhost", "port": 7004},
    {"host": "localhost", "port": 7005}
]

# 创建集群连接
client = RedisCluster(
    startup_nodes=startup_nodes,
    password="redis123456",
    decode_responses=True,
    skip_full_coverage_check=True,
    max_connections_per_node=10
)
```

## 📝 功能演示

- ✅ 集群连接和状态检查
- 📝 JSON数据存储和读取
- 🔢 原子计数器操作
- 📋 任务队列管理
- 🗂️ 会话数据存储