# 🔵 Go Redis Cluster 示例

## 🚀 运行示例

```bash
# 初始化模块
go mod tidy

# 运行示例
go run main.go

# 或编译后运行
go build -o redis-cluster-example
./redis-cluster-example
```

## 安装依赖

```bash
go mod init redis-cluster-example
go get github.com/redis/go-redis/v9
```

## 基本配置

```go
import "github.com/redis/go-redis/v9"

client := redis.NewClusterClient(&redis.ClusterOptions{
    Addrs: []string{
        "localhost:7000", "localhost:7001", "localhost:7002",
        "localhost:7003", "localhost:7004", "localhost:7005",
    },
    Password: "redis123456",
})
```

## 📝 功能演示

- ✅ 集群连接和状态监控
- 📝 结构体JSON序列化
- 🔢 并发安全计数器
- 📋 高性能队列操作
- 🗂️ 分布式缓存