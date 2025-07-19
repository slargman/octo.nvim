DEPS_DIR := .deps
DEPENDENCIES := nvim-lua/plenary.nvim \
                folke/snacks.nvim \
                nvim-telescope/telescope.nvim \
                ibhagwan/fzf-lua \
                nvim-tree/nvim-web-devicons \
                Bilal2453/luvit-meta

define check_stylua
	@command -v stylua >/dev/null 2>&1 || { \
		echo "❌ Error: stylua not found."; \
		echo ""; \
		echo "Install stylua using one of these methods:"; \
		echo "  • macOS:  brew install stylua"; \
		echo "  • Cargo:  cargo install stylua"; \
		echo "  • Binary: https://github.com/JohnnyMorganz/StyLua/releases"; \
		echo ""; \
		echo "Or see full installation instructions at:"; \
		echo "  https://github.com/JohnnyMorganz/StyLua#installation"; \
		echo ""; \
		exit 1; \
	}
endef

.DEFAULT_GOAL := help

# Phony targets don't create files
.PHONY: help setup test lint format clean

help: ## Show this help message
	@echo "octo.nvim development commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Usage: make <target>"

setup: ## Install development dependencies
	@echo "Setting up development environment..."
	@mkdir -p $(DEPS_DIR)
	@for dep in $(DEPENDENCIES); do \
		repo_name=$${dep##*/}; \
		if [ ! -d "$(DEPS_DIR)/$$repo_name" ]; then \
			echo "Installing $$repo_name..."; \
			git clone --depth 1 "https://github.com/$$dep.git" "$(DEPS_DIR)/$$repo_name"; \
		else \
			echo "$$repo_name already installed"; \
		fi \
	done
	@command -v stylua >/dev/null 2>&1 || echo "⚠️  Warning: stylua not found."

test: setup ## Run tests
	@echo "Running tests..."
	nvim --headless --noplugin -u lua/tests/minimal_init.lua \
		-c "PlenaryBustedDirectory lua/tests/ {minimal_init = 'lua/tests/minimal_init.lua'}"

lint: ## Check code style
	@echo "Checking code style..."
	$(call check_stylua)
	@stylua --check lua/

format: ## Format code
	@echo "Formatting code..."
	$(call check_stylua)
	@stylua lua/

clean: ## Remove development dependencies
	@echo "Cleaning development dependencies..."
	@rm -rf $(DEPS_DIR)
