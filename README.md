# 🚀 Redis Cluster

高可用Redis集群解决方案，基于Docker Compose和Bitnami镜像，适用于Mac ARM + Orbstack环境。

## ✨ 特性

- 🔗 **Redis Cluster模式** - 6节点集群(3主3从)，数据自动分片
- 🛡️ **高可用性** - 自动故障转移和负载均衡
- 📈 **水平扩展** - 支持动态添加节点
- 🎯 **管理界面** - Redis Insight可视化管理
- 📊 **监控支持** - Prometheus指标导出
- 🐳 **容器化部署** - 基于Bitnami专业镜像

## 🚀 快速开始

### 前置要求

- macOS ARM架构 (M1/M2/M3)
- Orbstack已安装并运行
- Docker Compose支持

### 启动集群

```bash
# 克隆项目
git clone <your-repo-url>
cd redis-cluster

# 启动集群
make start

# 或者直接使用脚本
./scripts/manage.sh start
```

### 验证集群

```bash
# 测试集群功能
make test

# 查看集群状态
make status
```

### 访问服务

- 🎯 **Redis Insight**: http://localhost:5540
- 📊 **监控指标**: http://localhost:9121
- 🔗 **Redis Cluster**: localhost:7000-7005

## 📋 可用命令

```bash
make start          # 🚀 启动Redis Cluster
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
├── docker-compose.yml           # Docker Compose配置
├── .gitignore                   # Git忽略文件
├── scripts/                     # 脚本目录
│   ├── manage.sh               # 管理脚本
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

## 🔗 连接信息

- **集群节点**: localhost:7000-7005
- **密码**: redis123456
- **集群模式**: 启用

## 📚 文档

- [📖 部署指南](docs/deployment.md)
- [📈 扩展指南](docs/scaling.md)
- [🏗️ 架构说明](docs/architecture.md)
- [🔍 故障排除](docs/troubleshooting.md)

## 💻 示例代码

查看 `examples/` 目录获取各种编程语言的连接示例：

- [☕ Java示例](examples/java/)
- [🟢 Node.js示例](examples/nodejs/)
- [🐍 Python示例](examples/python/)
- [🔵 Go示例](examples/go/)
- [💠 C#示例](examples/csharp/)
- [🐘 PHP示例](examples/php/)

## 🤝 贡献

欢迎提交Issues和Pull Requests！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解贡献指南。

## 📄 许可证

本项目采用 [MIT许可证](LICENSE)。

## ⭐ 支持

如果这个项目对你有帮助，请给我们一个Star！

---

**🎯 专为Mac ARM + Orbstack环境优化的Redis Cluster解决方案**