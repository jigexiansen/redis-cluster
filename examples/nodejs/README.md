# 🟢 Node.js Redis Cluster 示例

## 安装依赖

```bash
npm install redis
```

## 基本配置

```javascript
const redis = require('redis');

const client = redis.createCluster({
    rootNodes: [
        {host: 'localhost', port: 7000},
        {host: 'localhost', port: 7001},
        {host: 'localhost', port: 7002},
        {host: 'localhost', port: 7003},
        {host: 'localhost', port: 7004},
        {host: 'localhost', port: 7005}
    ],
    defaults: {
        password: 'redis123456'
    },
    options: {
        maxRetriesPerRequest: 3,
        retryDelayOnFailover: 100,
        enableOfflineQueue: false
    }
});
```

## 🚀 运行示例

```bash
# 安装依赖
npm install

# 运行示例
npm start

# 或直接运行
node redis-cluster-example.js
```

## 📝 功能演示

- ✅ 集群连接和状态检查
- 📝 基本键值操作
- 🔢 计数器操作
- 📋 列表队列操作
- 🗂️ 哈希表操作
- 🔐 会话管理示例