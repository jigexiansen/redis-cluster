# 🌲 Git分支和版本管理策略

## 📊 分支策略 (Git Flow)

### 🎯 主要分支

#### `main` - 生产分支
- 🔒 **受保护分支**
- ✅ 只包含稳定、经过测试的代码
- 🏷️ 每次合并都会创建发布标签
- 🚫 不允许直接推送，只能通过PR合并

#### `develop` - 开发分支
- 🔄 **集成分支**
- 🆕 最新的开发功能集成
- 🧪 CI/CD自动测试
- 📝 功能分支的合并目标

### 🔀 辅助分支

#### `feature/*` - 功能分支
```bash
# 创建功能分支
git checkout develop
git checkout -b feature/redis-sentinel-support

# 开发完成后合并到develop
git checkout develop
git merge --no-ff feature/redis-sentinel-support
```

#### `release/*` - 发布分支
```bash
# 创建发布分支
git checkout develop
git checkout -b release/v1.1.0

# 发布准备完成后
git checkout main
git merge --no-ff release/v1.1.0
git tag -a v1.1.0 -m "Release v1.1.0"
```

#### `hotfix/*` - 热修复分支
```bash
# 紧急修复
git checkout main
git checkout -b hotfix/security-patch

# 修复完成后同时合并到main和develop
git checkout main
git merge --no-ff hotfix/security-patch
git checkout develop
git merge --no-ff hotfix/security-patch
```

## 🏷️ 版本标签策略

### 📋 语义化版本 (Semantic Versioning)

格式：`vMAJOR.MINOR.PATCH[-PRERELEASE]`

- **MAJOR**: 不兼容的重大变更
- **MINOR**: 向后兼容的功能新增
- **PATCH**: 向后兼容的问题修复
- **PRERELEASE**: alpha, beta, rc

### 🎯 标签示例

```bash
v1.0.0        # 首个稳定版本
v1.1.0        # 新增功能
v1.1.1        # 修复问题
v2.0.0        # 重大版本更新
v2.0.0-alpha  # 预发布版本
v2.0.0-beta   # 测试版本
v2.0.0-rc.1   # 发布候选版本
```

## 🔄 工作流程

### 📝 新功能开发

1. **创建功能分支**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/new-monitoring-dashboard
   ```

2. **开发和提交**
   ```bash
   git add .
   git commit -m "feat: add monitoring dashboard with Grafana integration"
   ```

3. **推送并创建PR**
   ```bash
   git push origin feature/new-monitoring-dashboard
   # 在GitHub创建PR: feature/new-monitoring-dashboard -> develop
   ```

### 🚀 版本发布流程

1. **创建发布分支**
   ```bash
   git checkout develop
   git checkout -b release/v1.2.0
   ```

2. **版本准备**
   - 更新版本号
   - 更新CHANGELOG.md
   - 最终测试

3. **发布**
   ```bash
   git checkout main
   git merge --no-ff release/v1.2.0
   git tag -a v1.2.0 -m "Release v1.2.0: Add monitoring dashboard"
   git push origin main --tags
   
   git checkout develop
   git merge --no-ff release/v1.2.0
   git push origin develop
   ```

## 🛡️ 分支保护规则

### `main` 分支保护
- ✅ 要求PR审查
- ✅ 要求状态检查通过
- ✅ 要求分支为最新
- 🚫  限制推送
- 🚫  限制强制推送

### `develop` 分支保护
- ✅ 要求PR审查
- ✅ 要求CI通过
- ✅ 允许管理员绕过

## 📋 提交信息规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 格式：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### 🎯 类型说明
- `feat`: 新功能
- `fix`: 修复问题
- `docs`: 文档更新
- `style`: 格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

### 💡 示例
```bash
feat(monitoring): add Grafana dashboard integration
fix(cluster): resolve connection timeout issue
docs(readme): update installation instructions
chore(deps): bump redis version to 7.4.1
```

## 🔄 发布日志

维护 [CHANGELOG.md](../CHANGELOG.md) 记录版本变更：

```markdown
## [1.2.0] - 2025-01-XX

### Added
- 🎯 Grafana监控仪表板集成
- 📊 性能指标收集

### Changed
- ⬆️ 升级Redis到7.4.1
- 🔧 优化Docker Compose配置

### Fixed
- 🐛 修复集群连接超时问题
```

---

遵循这个策略可以确保项目的代码质量和版本管理的专业性！