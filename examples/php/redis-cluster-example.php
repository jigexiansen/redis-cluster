<?php
/**
 * 🐘 PHP Redis Cluster 连接示例
 * 
 * 使用Predis库连接Redis Cluster
 */

require_once 'vendor/autoload.php';

use Predis\Client;

function main() {
    echo "🚀 连接Redis Cluster...\n";
    
    try {
        // 创建集群客户端配置
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
        
        // 创建Redis Cluster客户端
        $client = new Client($parameters, $options);
        
        // 测试连接
        $pong = $client->ping();
        echo "✅ 成功连接到Redis Cluster: {$pong}\n";
        
        // 🔍 获取集群信息
        echo "\n📊 集群信息:\n";
        try {
            $clusterInfo = $client->executeRaw(['CLUSTER', 'INFO']);
            echo "集群状态: " . (strpos($clusterInfo, 'cluster_state:ok') !== false ? '正常' : '异常') . "\n";
        } catch (Exception $e) {
            echo "⚠️ 无法获取集群信息: " . $e->getMessage() . "\n";
        }
        
        // 📝 写入测试数据
        echo "\n📝 写入测试数据...\n";
        for ($i = 1; $i <= 10; $i++) {
            $userData = [
                'id' => $i,
                'name' => "用户{$i}",
                'email' => "user{$i}@example.com",
                'timestamp' => date('c')
            ];
            
            $client->set("user:{$i}", json_encode($userData, JSON_UNESCAPED_UNICODE));
        }
        echo "✅ 写入10条用户数据\n";
        
        // 📖 读取测试数据
        echo "\n📖 读取测试数据...\n";
        for ($i = 1; $i <= 5; $i++) {
            $userData = $client->get("user:{$i}");
            if ($userData) {
                $user = json_decode($userData, true);
                echo "👤 用户{$i}: {$user['name']} {$user['email']}\n";
            }
        }
        
        // 🔢 计数器示例
        echo "\n🔢 计数器示例...\n";
        $client->set('counter', 0);
        for ($i = 0; $i < 5; $i++) {
            $count = $client->incr('counter');
            echo "📊 计数器值: {$count}\n";
        }
        
        // 📋 列表操作示例
        echo "\n📋 列表操作示例...\n";
        $client->del('task_queue');
        $client->lpush('task_queue', '任务1', '任务2', '任务3');
        $queueLength = $client->llen('task_queue');
        echo "📝 队列长度: {$queueLength}\n";
        
        $task = $client->rpop('task_queue');
        echo "✅ 处理任务: {$task}\n";
        
        // 🗂️ 哈希操作示例
        echo "\n🗂️ 哈希操作示例...\n";
        $sessionData = [
            'userId' => '1001',
            'username' => '张三',
            'loginTime' => date('c'),
            'ip' => '192.168.1.100'
        ];
        
        $client->hmset('session:abc123', $sessionData);
        $session = $client->hgetall('session:abc123');
        echo "🔐 会话信息:\n";
        foreach ($session as $key => $value) {
            echo "  {$key}: {$value}\n";
        }
        
        // 🔍 集合操作示例
        echo "\n🔍 集合操作示例...\n";
        $client->del('online_users');
        $client->sadd('online_users', 'user1', 'user2', 'user3', 'user4');
        $onlineCount = $client->scard('online_users');
        echo "👥 在线用户数: {$onlineCount}\n";
        
        $randomUser = $client->spop('online_users');
        echo "🔀 随机用户: {$randomUser}\n";
        
        // ⏰ 有序集合示例 (排行榜)
        echo "\n⏰ 有序集合示例 (排行榜)...\n";
        $client->del('leaderboard');
        $client->zadd('leaderboard', 100, '玩家A', 85, '玩家B', 95, '玩家C', 120, '玩家D');
        
        $topPlayers = $client->zrevrange('leaderboard', 0, 2, 'WITHSCORES');
        echo "🏆 排行榜前3名:\n";
        for ($i = 0; $i < count($topPlayers); $i += 2) {
            $rank = ($i / 2) + 1;
            $player = $topPlayers[$i];
            $score = $topPlayers[$i + 1];
            echo "  {$rank}. {$player}: {$score}分\n";
        }
        
        // 💾 设置过期时间示例
        echo "\n💾 设置过期时间示例...\n";
        $client->setex('temp_token', 60, 'temporary_access_token_12345');
        $ttl = $client->ttl('temp_token');
        echo "🕐 临时令牌剩余时间: {$ttl}秒\n";
        
        echo "\n🎉 所有测试完成！\n";
        
    } catch (Exception $e) {
        echo "❌ 错误: " . $e->getMessage() . "\n";
        echo "🔍 错误详情: " . $e->getTraceAsString() . "\n";
    }
    
    echo "👋 断开连接\n";
}

// 运行示例
if (php_sapi_name() === 'cli') {
    main();
} else {
    echo "⚠️ 请在命令行环境下运行此示例\n";
}