#!/usr/bin/env node

// 🟢 Node.js Redis Cluster 连接示例

const redis = require('redis');

async function main() {
    console.log('🚀 连接Redis Cluster...');
    
    // 创建集群客户端
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

    try {
        // 连接到集群
        await client.connect();
        console.log('✅ 成功连接到Redis Cluster');

        // 🔍 获取集群信息
        const clusterInfo = await client.sendCommand(['CLUSTER', 'INFO']);
        console.log('📊 集群信息:', clusterInfo);

        // 📝 写入测试数据
        console.log('\n📝 写入测试数据...');
        for (let i = 1; i <= 10; i++) {
            await client.set(`user:${i}`, JSON.stringify({
                id: i,
                name: `用户${i}`,
                email: `user${i}@example.com`,
                timestamp: new Date().toISOString()
            }));
        }
        console.log('✅ 写入10条用户数据');

        // 📖 读取测试数据
        console.log('\n📖 读取测试数据...');
        for (let i = 1; i <= 5; i++) {
            const userData = await client.get(`user:${i}`);
            const user = JSON.parse(userData);
            console.log(`👤 用户${i}:`, user.name, user.email);
        }

        // 🔢 计数器示例
        console.log('\n🔢 计数器示例...');
        await client.set('counter', 0);
        for (let i = 0; i < 5; i++) {
            const count = await client.incr('counter');
            console.log(`📊 计数器值: ${count}`);
        }

        // 📋 列表操作示例
        console.log('\n📋 列表操作示例...');
        await client.del('task_queue');
        await client.lPush('task_queue', ['任务1', '任务2', '任务3']);
        const queueLength = await client.lLen('task_queue');
        console.log(`📝 队列长度: ${queueLength}`);
        
        const task = await client.rPop('task_queue');
        console.log(`✅ 处理任务: ${task}`);

        // 🗂️ 哈希操作示例
        console.log('\n🗂️ 哈希操作示例...');
        await client.hSet('session:abc123', {
            userId: '1001',
            username: '张三',
            loginTime: new Date().toISOString(),
            ip: '192.168.1.100'
        });
        
        const session = await client.hGetAll('session:abc123');
        console.log('🔐 会话信息:', session);

        console.log('\n🎉 所有测试完成！');

    } catch (error) {
        console.error('❌ 错误:', error.message);
    } finally {
        await client.disconnect();
        console.log('👋 断开连接');
    }
}

// 运行示例
if (require.main === module) {
    main().catch(console.error);
}

module.exports = { main };