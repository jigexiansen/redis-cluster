# 🤝 贡献指南

感谢你对Redis Cluster项目的兴趣！

## 🚀 如何贡献

### 报告问题

1. 检查 [Issues](../../issues) 确保问题尚未报告
2. 使用Issue模板创建新的问题报告
3. 提供详细的重现步骤和环境信息

### 提交功能请求

1. 在 [Issues](../../issues) 中描述你的功能需求
2. 解释为什么这个功能对项目有价值
3. 如果可能，提供设计建议

### 代码贡献

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

## 📋 开发准备

```bash
# 克隆项目
git clone <your-fork-url>
cd redis-cluster

# 检查环境
make setup

# 启动开发环境
make dev
```

## 🧪 测试

在提交代码前，请确保：

```bash
# 验证配置
make validate

# 测试集群功能
make test

# 检查日志
make logs
```

## 📝 代码规范

- 使用有意义的提交信息
- 遵循现有的代码风格
- 添加适当的注释和文档
- 更新相关的README文档

## 🎯 Pull Request指南

- PR标题应该清晰描述更改内容
- 包含详细的描述和测试步骤
- 确保所有检查通过
- 链接相关的Issues

谢谢你的贡献！🎉