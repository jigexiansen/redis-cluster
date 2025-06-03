# 🚀 Redis Cluster

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Redis](https://img.shields.io/badge/Redis-7.4-red.svg)](https://redis.io/)

高可用Redis集群解决方案，基于Docker Compose和官方Redis镜像，使用独立节点自动创建集群，适用于Mac ARM + Orbstack环境。

## ✨ 特性

- 🔗 **Redis Cluster模式** - 6节点集群(3主3从)，数据自动分片
- 🛡️ **高可用性** - 自动故障转移和负载均衡
- 📈 **水平扩展** - 支持动态添加节点
- 🎯 **管理界面** - Redis Insight可视化管理
- 📊 **监控支持** - Prometheus指标导出
- 🐳 **容器化部署** - 基于官方Redis镜像，独立节点设计
- 🔧 **自动集群创建** - 一键启动，自动检测和创建集群

## 🚀 快速开始

### 前置要求

- **操作系统**: macOS ARM架构 (M1/M2/M3/M4)
- **容器环境**: [OrbStack](https://orbstack.dev/) 已安装并运行
- **Docker**: Docker 20.10+ 和 Docker Compose V2
- **内存**: 建议4GB+可用内存
- **端口**: 确保7000-7005、17000-17005、5540、9121端口可用

### 启动集群

```bash
# 克隆项目
git clone https://github.com/jigexiansen/redis-cluster.git
cd redis-cluster

# 一键启动集群（包含自动创建集群）
make start

# 或者直接使用脚本
./scripts/manage.sh start
```

### 验证集群

```bash
# 检查环境
make setup

# 测试集群功能
make test

# 查看集群状态
make status

# 查看详细集群信息
make cluster-info
```

### 访问服务

- 🎯 **Redis Insight**: http://localhost:5540
- 📊 **监控指标**: http://localhost:9121
- 🔗 **Redis Cluster**: localhost:7000-7005

## 📋 可用命令

```bash
make start          # 🚀 启动Redis Cluster并自动创建集群
make stop           # ⏹️ 停止集群
make restart        # 🔄 重启集群
make status         # 📊 查看集群状态
make test           # 🧪 测试集群功能
make logs           # 📝 查看日志
make backup         # 💾 备份数据
make clean          # 🧹 清理环境
```

## 📁 项目结构

```
redis-cluster/
├── README.md                    # 项目说明
├── LICENSE                      # 开源许可证
├── Makefile                     # 构建命令
├── docker-compose.yml           # Docker Compose配置（基于官方Redis镜像）
├── .gitignore                   # Git忽略文件
├── scripts/                     # 脚本目录
│   ├── manage.sh               # 管理脚本（包含自动集群创建）
│   ├── setup.sh                # 安装脚本
│   └── cleanup.sh              # 清理脚本
├── docs/                        # 文档目录
│   ├── deployment.md           # 部署文档
│   ├── scaling.md              # 扩展指南
│   ├── architecture.md         # 架构说明
│   └── troubleshooting.md      # 故障排除
└── examples/                    # 示例代码
    ├── java/                   # Java连接示例
    ├── nodejs/                 # Node.js连接示例
    ├── python/                 # Python连接示例
    ├── go/                     # Go连接示例
    ├── csharp/                 # C#连接示例
    └── php/                    # PHP连接示例
```

## 🏗️ 技术架构

### 🐳 镜像选择
- **Redis镜像**: redis:7.4 (官方镜像)
- **部署方式**: 独立节点启动 + 自动集群创建
- **优势**: 稳定可靠，无依赖第三方镜像问题

### 🔧 集群创建流程
1. **启动独立节点**: 6个Redis实例独立启动，启用集群模式
2. **自动检测**: 检查是否已存在集群配置
3. **创建集群**: 如无集群，自动执行集群创建命令
4. **验证状态**: 确认集群状态正常

## 🔗 连接信息

- **集群节点**: localhost:7000-7005
- **密码**: redis123456
- **集群模式**: 启用

### 💻 Redis CLI连接

**推荐方式（避免I/O错误）:**
```bash
# 使用项目提供的便捷连接脚本
make connect

# 或者直接运行脚本
./scripts/redis-cli.sh
```

**手动连接方式:**
```bash
# 通过Docker容器连接（推荐）
docker exec -it redis-node-0 redis-cli -c -a redis123456 --no-auth-warning

# 本地redis-cli连接（可能出现I/O错误）
redis-cli -c -h localhost -p 7000 -a redis123456 --no-auth-warning
```

**⚠️ 连接问题说明:**
在Mac ARM + OrbStack环境中，本地redis-cli可能出现I/O错误或连接缓慢，这是端口映射兼容性问题。建议使用Docker内部连接方式。

**测试集群连接:**
```bash
# 连接后执行
127.0.0.1:6379> cluster info
127.0.0.1:6379> set test "hello world"
127.0.0.1:6379> get test
```

## 📚 文档

- [📖 部署指南](docs/deployment.md)
- [📈 扩展指南](docs/scaling.md)
- [🏗️ 架构说明](docs/architecture.md)
- [🔍 故障排除](docs/troubleshooting.md)

## 💻 示例代码

查看 `examples/` 目录获取各种编程语言的Redis Cluster连接示例：

- [☕ Java示例](examples/java/) - 基于Jedis客户端
- [🟢 Node.js示例](examples/nodejs/) - 基于redis客户端
- [🐍 Python示例](examples/python/) - 基于redis-py-cluster
- [🔵 Go示例](examples/go/) - 基于go-redis/v9
- [💠 C#示例](examples/csharp/) - 基于StackExchange.Redis
- [🐘 PHP示例](examples/php/) - 基于Predis客户端

每个示例都包含：
- ✅ 完整的连接配置
- 📝 基础CRUD操作演示
- 🔢 计数器和队列操作
- 🗂️ 高级数据结构使用

## 🤝 贡献

欢迎提交Issues和Pull Requests！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解贡献指南。

## 📄 许可证

本项目采用 [MIT许可证](LICENSE)。

## 🔧 故障排除

遇到问题？查看常见解决方案：

- 🚨 [常见问题解答](docs/troubleshooting.md)
- 🐳 [Docker相关问题](docs/troubleshooting.md#docker-issues)
- 🔌 [连接问题](docs/troubleshooting.md#connection-issues)
- 📊 [性能优化](docs/troubleshooting.md#performance-tuning)

## ⭐ 支持

如果这个项目对你有帮助，请给我们一个Star！

### 🤝 社区

- 💬 [提交问题](https://github.com/jigexiansen/redis-cluster/issues)
- 🔄 [贡献代码](https://github.com/jigexiansen/redis-cluster/pulls)
- 📖 [查看文档](docs/)

---

**🎯 专为Mac ARM + Orbstack环境优化的Redis Cluster解决方案**  
**✨ 基于官方Redis镜像，独立节点设计，一键自动创建集群**