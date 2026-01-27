# =============================================
# Global Docker Compose configuration
# =============================================

COMPOSE = docker compose \
	--project-name go-clean-architecture-api-starter \
	--project-directory .

# Base migrate command executed as a one-off service
MIGRATE_CMD = $(COMPOSE) run --rm migrate

# =============================================
# Default target
# =============================================

.PHONY: default
default: help

# =============================================
# Help
# =============================================

.PHONY: help
help: ## Show all available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# =============================================
# Basic lifecycle commands
# =============================================

.PHONY: up
up: ## Start all services and apply database migrations
	@echo "==> Starting services..."
	$(COMPOSE) up -d
	@echo "==> Giving database a few seconds to boot..."
	sleep 5
	@echo "==> Applying database migrations (up)..."
	$(MIGRATE_CMD) up

.PHONY: stop
stop: ## Stop all running services without removing containers
	@echo "==> Stopping all services..."
	$(COMPOSE) stop || true

.PHONY: down
down: ## Remove all containers, networks and volumes for this project
	@echo "==> Removing all services, networks and volumes..."
	$(COMPOSE) down --remove-orphans --volumes

# =============================================
# Manual migration commands (optional)
# =============================================

.PHONY: migrate
migrate: ## Apply all pending migrations
	@echo "==> Applying database migrations (up)..."
	$(MIGRATE_CMD) up

.PHONY: migrate-down
migrate-down: ## Revert the last migration
	@echo "==> Reverting last migration (down 1)..."
	$(MIGRATE_CMD) down 1

.PHONY: migrate-reset
migrate-reset: ## Drop DB and apply all migrations again
	@echo "==> Dropping database (migrate drop)..."
	$(MIGRATE_CMD) drop
	@echo "==> Re-applying all migrations (migrate up)..."
	$(MIGRATE_CMD) up
