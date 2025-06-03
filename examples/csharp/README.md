# 💠 C# Redis Cluster 示例

## 🚀 运行示例

```bash
# 恢复包依赖
dotnet restore

# 运行示例
dotnet run

# 或发布后运行
dotnet publish -c Release
dotnet bin/Release/net8.0/RedisClusterExample.dll
```

## 包依赖

```xml
<PackageReference Include="StackExchange.Redis" Version="2.7.10" />
<PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
```

## 基本配置

```csharp
using StackExchange.Redis;

var options = ConfigurationOptions.Parse("localhost:7000,localhost:7001,localhost:7002,localhost:7003,localhost:7004,localhost:7005");
options.Password = "redis123456";

var connection = ConnectionMultiplexer.Connect(options);
var database = connection.GetDatabase();
```

## 📝 功能演示

- ✅ 集群连接和健康检查
- 📝 对象序列化和反序列化
- 🔢 原子操作和事务
- 📋 异步队列处理
- 🗂️ 分布式锁和缓存