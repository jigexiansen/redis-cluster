# 📋 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-01-03

### 🚀 Major Updates - 架构重构

#### 🔄 Breaking Changes
- **镜像迁移**: 从`bitnami/redis-cluster:7.4`迁移到官方`redis:7.4`镜像
- **集群创建方式**: 改为独立节点启动 + 自动集群创建模式
- **启动流程**: `make start`现在包含完整的集群创建过程

#### ✨ Added
- 🔧 **自动集群创建**: 启动脚本自动检测并创建Redis集群
- 🔍 **智能检测**: 自动检查集群状态，避免重复创建
- 📋 **简化命令**: 移除`create-cluster`命令，集成到`start`命令中
- 🛡️ **增强稳定性**: 使用官方镜像，避免第三方依赖问题
- 📝 **完善文档**: 更新架构说明和故障排除指南

#### 🔧 Changed
- **Docker配置**: 重构`docker-compose.yml`使用官方Redis镜像
- **管理脚本**: 更新`scripts/manage.sh`集成自动集群创建
- **数据路径**: 从`/bitnami/redis/data`改为`/data`
- **启动时间**: 优化启动等待时间从30秒减少到15秒

#### 🐛 Fixed
- ❌ **镜像兼容性**: 解决bitnami镜像的`REDIS_CLUSTER_ANNOUNCE_IP`错误
- 🔗 **集群初始化**: 修复自动集群创建失败的问题
- 📊 **状态检测**: 改进集群状态检测逻辑
- 💾 **备份路径**: 修复备份脚本的文件路径问题

#### 📚 Documentation
- 📖 **README更新**: 反映新的架构和使用方式
- 🏗️ **架构文档**: 详细说明独立节点 + 自动集群创建的方式
- 🔍 **故障排除**: 添加新架构相关的常见问题和解决方案
- 💡 **最佳实践**: 更新部署和运维建议

## [1.0.0] - 2025-01-03

### 🎉 Initial Release

#### Added
- 🔗 **Redis Cluster**: 6-node cluster (3 masters, 3 replicas) with automatic sharding
- 🐳 **Docker Compose**: Production-ready deployment with Bitnami Redis Cluster 7.4
- 🎯 **Management Interface**: Redis Insight web GUI for cluster visualization
- 📊 **Monitoring**: Prometheus metrics exporter for performance tracking
- 🛡️ **Security**: Password authentication and data persistence
- 🌐 **Network**: Isolated Docker network with health checks

#### 💻 Multi-Language Examples
- ☕ **Java**: Complete example with Jedis client
- 🟢 **Node.js**: Redis cluster client with error handling
- 🐍 **Python**: redis-py-cluster implementation
- 🔵 **Go**: go-redis/v9 cluster client
- 💠 **C#**: StackExchange.Redis cluster support
- 🐘 **PHP**: Predis cluster client with comprehensive operations

#### 🔧 Management Tools
- 📋 **Makefile**: Convenient commands for common operations
- 🛠️ **Scripts**: Setup, management, and cleanup automation
- 📚 **Documentation**: Complete guides for deployment and scaling
- 🤝 **Contributing**: Guidelines for open source contributions

#### 🎯 Platform Support
- **macOS ARM**: Optimized for M1/M2/M3/M4 processors
- **OrbStack**: Enhanced Docker Desktop alternative
- **Cross-platform**: Compatible with standard Docker environments

### 📋 Technical Specifications
- **Redis Version**: 7.4 (Official images)
- **Cluster Nodes**: 6 (configurable)
- **Ports**: 7000-7005 (Redis) + 17000-17005 (Cluster bus)
- **Management**: 5540 (Redis Insight) + 9121 (Metrics)
- **License**: MIT

---

## 🚀 Future Roadmap

### 🎯 Planned Features
- 📈 **v1.2.0**: Grafana dashboard integration
- 🔧 **v1.3.0**: Redis Sentinel support
- 🌐 **v1.4.0**: Kubernetes deployment manifests
- 🔒 **v1.5.0**: SSL/TLS encryption support
- 🏗️ **v2.0.0**: Multi-cluster federation

---

**Note**: This project follows [Semantic Versioning](https://semver.org/). For upgrade instructions and migration guides, see our [documentation](docs/).