# 🐘 PHP Redis Cluster 示例

## 🚀 运行示例

```bash
# 安装依赖
composer install

# 运行示例
php redis-cluster-example.php

# 或使用composer脚本
composer test
```

## 环境要求

- PHP 8.0+
- Composer
- Predis扩展

## 安装依赖

```bash
# 使用Composer安装
composer install

# 或手动安装Predis
composer require predis/predis
```

## 基本配置

```php
<?php
require_once 'vendor/autoload.php';

use Predis\Client;

// 集群节点配置
$parameters = [
    'tcp://localhost:7000?password=redis123456',
    'tcp://localhost:7001?password=redis123456',
    'tcp://localhost:7002?password=redis123456',
    'tcp://localhost:7003?password=redis123456',
    'tcp://localhost:7004?password=redis123456',
    'tcp://localhost:7005?password=redis123456',
];

$options = [
    'cluster' => 'redis',
    'parameters' => [
        'password' => 'redis123456',
    ],
];

// 创建客户端
$client = new Client($parameters, $options);
```

## 📝 功能演示

- ✅ 集群连接和状态检查
- 📝 JSON数据存储和检索
- 🔢 原子计数器操作
- 📋 列表队列管理
- 🗂️ 哈希表操作
- 🔍 集合运算
- ⏰ 有序集合排行榜
- 💾 TTL过期时间管理

## 🔧 高级配置

### 连接池配置

```php
$options = [
    'cluster' => 'redis',
    'parameters' => [
        'password' => 'redis123456',
        'read_write_timeout' => 60,
        'tcp_keepalive' => 1,
    ],
    'connections' => [
        'tcp' => [
            'persistent' => true,
            'timeout' => 5.0,
        ],
    ],
];
```

### 错误处理

```php
try {
    $result = $client->get('key');
} catch (Predis\Connection\ConnectionException $e) {
    echo "连接错误: " . $e->getMessage();
} catch (Predis\Response\ServerException $e) {
    echo "服务器错误: " . $e->getMessage();
}
```