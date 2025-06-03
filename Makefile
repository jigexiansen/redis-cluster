# 🚀 Redis Cluster Makefile
# 方便的命令行接口

.PHONY: help start stop restart status test logs backup clean setup

# 默认目标
.DEFAULT_GOAL := help

help: ## 📋 显示帮助信息
	@echo "🚀 Redis Cluster 管理命令"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

start: ## 🚀 启动Redis Cluster
	@./scripts/manage.sh start

stop: ## ⏹️ 停止Redis Cluster
	@./scripts/manage.sh stop

restart: ## 🔄 重启Redis Cluster
	@./scripts/manage.sh restart

status: ## 📊 查看集群状态
	@./scripts/manage.sh status

test: ## 🧪 测试集群功能
	@./scripts/manage.sh test

cluster-info: ## 🔍 显示详细集群信息
	@./scripts/manage.sh cluster-info

logs: ## 📝 查看日志
	@./scripts/manage.sh logs

backup: ## 💾 备份集群数据
	@./scripts/manage.sh backup

clean: ## 🧹 清理数据和容器
	@./scripts/manage.sh clean

setup: ## ⚙️ 初始化环境
	@echo "🔧 检查环境依赖..."
	@command -v docker >/dev/null 2>&1 || { echo "❌ Docker未安装"; exit 1; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "❌ Docker Compose未安装"; exit 1; }
	@echo "✅ 环境检查通过"
	@echo "🚀 可以使用 'make start' 启动集群"

validate: ## ✅ 验证配置文件
	@echo "🔍 验证Docker Compose配置..."
	@docker-compose config > /dev/null
	@echo "✅ 配置文件验证通过"

dev: ## 🛠️ 开发模式 (启动+日志)
	@make start
	@sleep 5
	@make logs