#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
🐍 Python Redis Cluster 连接示例
"""

import json
import time
from datetime import datetime
from redis.cluster import RedisCluster

def main():
    print("🚀 连接Redis Cluster...")
    
    # 集群节点配置
    startup_nodes = [
        {"host": "localhost", "port": 7000},
        {"host": "localhost", "port": 7001},
        {"host": "localhost", "port": 7002},
        {"host": "localhost", "port": 7003},
        {"host": "localhost", "port": 7004},
        {"host": "localhost", "port": 7005}
    ]
    
    try:
        # 创建集群连接
        client = RedisCluster(
            startup_nodes=startup_nodes,
            password="redis123456",
            decode_responses=True,
            skip_full_coverage_check=True,
            max_connections_per_node=10
        )
        
        print("✅ 成功连接到Redis Cluster")
        
        # 🔍 获取集群信息
        cluster_info = client.execute_command("CLUSTER", "INFO")
        print(f"📊 集群信息: {cluster_info}")
        
        # 📝 写入测试数据
        print("\n📝 写入测试数据...")
        for i in range(1, 11):
            user_data = {
                "id": i,
                "name": f"用户{i}",
                "email": f"user{i}@example.com",
                "timestamp": datetime.now().isoformat()
            }
            client.set(f"user:{i}", json.dumps(user_data, ensure_ascii=False))
        
        print("✅ 写入10条用户数据")
        
        # 📖 读取测试数据
        print("\n📖 读取测试数据...")
        for i in range(1, 6):
            user_json = client.get(f"user:{i}")
            if user_json:
                user = json.loads(user_json)
                print(f"👤 用户{i}: {user['name']} {user['email']}")
        
        # 🔢 计数器示例
        print("\n🔢 计数器示例...")
        client.set("counter", 0)
        for i in range(5):
            count = client.incr("counter")
            print(f"📊 计数器值: {count}")
        
        # 📋 列表操作示例
        print("\n📋 列表操作示例...")
        client.delete("task_queue")
        client.lpush("task_queue", "任务1", "任务2", "任务3")
        queue_length = client.llen("task_queue")
        print(f"📝 队列长度: {queue_length}")
        
        task = client.rpop("task_queue")
        print(f"✅ 处理任务: {task}")
        
        # 🗂️ 哈希操作示例
        print("\n🗂️ 哈希操作示例...")
        session_data = {
            "userId": "1001",
            "username": "张三",
            "loginTime": datetime.now().isoformat(),
            "ip": "192.168.1.100"
        }
        client.hset("session:abc123", mapping=session_data)
        
        session = client.hgetall("session:abc123")
        print(f"🔐 会话信息: {session}")
        
        print("\n🎉 所有测试完成！")
        
    except Exception as error:
        print(f"❌ 错误: {error}")
    
    print("👋 断开连接")

if __name__ == "__main__":
    main()