package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/redis/go-redis/v9"
)

// User 用户结构体
type User struct {
	ID        int    `json:"id"`
	Name      string `json:"name"`
	Email     string `json:"email"`
	Timestamp string `json:"timestamp"`
}

func main() {
	fmt.Println("🚀 连接Redis Cluster...")

	// 创建集群客户端
	client := redis.NewClusterClient(&redis.ClusterOptions{
		Addrs:    []string{"localhost:7000", "localhost:7001", "localhost:7002", "localhost:7003", "localhost:7004", "localhost:7005"},
		Password: "redis123456",
	})

	ctx := context.Background()

	// 测试连接
	_, err := client.Ping(ctx).Result()
	if err != nil {
		log.Fatalf("❌ 连接失败: %v", err)
	}
	fmt.Println("✅ 成功连接到Redis Cluster")

	// 🔍 获取集群信息
	clusterInfo, err := client.ClusterInfo(ctx).Result()
	if err != nil {
		log.Printf("⚠️ 获取集群信息失败: %v", err)
	} else {
		fmt.Printf("📊 集群信息: %s\n", clusterInfo)
	}

	// 📝 写入测试数据
	fmt.Println("\n📝 写入测试数据...")
	for i := 1; i <= 10; i++ {
		user := User{
			ID:        i,
			Name:      fmt.Sprintf("用户%d", i),
			Email:     fmt.Sprintf("user%d@example.com", i),
			Timestamp: time.Now().Format(time.RFC3339),
		}

		userData, _ := json.Marshal(user)
		err := client.Set(ctx, fmt.Sprintf("user:%d", i), userData, 0).Err()
		if err != nil {
			log.Printf("❌ 写入用户%d失败: %v", i, err)
		}
	}
	fmt.Println("✅ 写入10条用户数据")

	// 📖 读取测试数据
	fmt.Println("\n📖 读取测试数据...")
	for i := 1; i <= 5; i++ {
		userData, err := client.Get(ctx, fmt.Sprintf("user:%d", i)).Result()
		if err != nil {
			log.Printf("❌ 读取用户%d失败: %v", i, err)
			continue
		}

		var user User
		json.Unmarshal([]byte(userData), &user)
		fmt.Printf("👤 用户%d: %s %s\n", i, user.Name, user.Email)
	}

	// 🔢 计数器示例
	fmt.Println("\n🔢 计数器示例...")
	client.Set(ctx, "counter", 0, 0)
	for i := 0; i < 5; i++ {
		count, err := client.Incr(ctx, "counter").Result()
		if err != nil {
			log.Printf("❌ 计数器操作失败: %v", err)
			continue
		}
		fmt.Printf("📊 计数器值: %d\n", count)
	}

	// 📋 列表操作示例
	fmt.Println("\n📋 列表操作示例...")
	client.Del(ctx, "task_queue")
	client.LPush(ctx, "task_queue", "任务1", "任务2", "任务3")
	queueLength, _ := client.LLen(ctx, "task_queue").Result()
	fmt.Printf("📝 队列长度: %d\n", queueLength)

	task, err := client.RPop(ctx, "task_queue").Result()
	if err != nil {
		log.Printf("❌ 队列操作失败: %v", err)
	} else {
		fmt.Printf("✅ 处理任务: %s\n", task)
	}

	// 🗂️ 哈希操作示例
	fmt.Println("\n🗂️ 哈希操作示例...")
	sessionData := map[string]interface{}{
		"userId":    "1001",
		"username":  "张三",
		"loginTime": time.Now().Format(time.RFC3339),
		"ip":        "192.168.1.100",
	}

	client.HSet(ctx, "session:abc123", sessionData)
	session, err := client.HGetAll(ctx, "session:abc123").Result()
	if err != nil {
		log.Printf("❌ 哈希操作失败: %v", err)
	} else {
		fmt.Printf("🔐 会话信息: %+v\n", session)
	}

	fmt.Println("\n🎉 所有测试完成！")
	fmt.Println("👋 断开连接")
}