# ☕ Java Redis Cluster 示例

## 🚀 运行示例

```bash
# 编译和运行
mvn compile exec:java -Dexec.mainClass="RedisClusterExample"

# 或者打包后运行
mvn package
java -jar target/redis-cluster-java-example-1.0.0.jar
```

## 依赖配置

### Maven (pom.xml)
```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>5.1.0</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.16.1</version>
</dependency>
```

## 基本配置

```java
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.HostAndPort;

Set<HostAndPort> nodes = new HashSet<>();
nodes.add(new HostAndPort("localhost", 7000));
nodes.add(new HostAndPort("localhost", 7001));
nodes.add(new HostAndPort("localhost", 7002));
nodes.add(new HostAndPort("localhost", 7003));
nodes.add(new HostAndPort("localhost", 7004));
nodes.add(new HostAndPort("localhost", 7005));

JedisCluster jedis = new JedisCluster(nodes, "redis123456");
```

## 📝 功能演示

- ✅ 集群连接和健康检查
- 📝 对象序列化存储
- 🔢 分布式计数器
- 📋 消息队列操作
- 🗂️ 缓存管理