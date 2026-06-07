# CV Builder — developer command entrypoint.
# Thin wrappers around the pnpm/turbo scripts that CI also runs, so
# `make ci` locally matches what GitHub Actions enforces on your PR.

.DEFAULT_GOAL := help
.PHONY: help install dev build typecheck test lint format fix check ci clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "} {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies (frozen lockfile)
	pnpm install --frozen-lockfile

dev: ## Run all packages in watch mode
	pnpm dev

build: ## Build all packages
	pnpm build

typecheck: ## Type-check all packages (tsc --noEmit)
	pnpm typecheck

test: ## Run the test suite
	pnpm test

lint: ## Lint + format check (Biome, read-only)
	pnpm lint

format: ## Apply Biome formatting and safe fixes
	pnpm format

fix: format ## Alias for `make format`

check: lint typecheck ## Lint + typecheck (no tests/build)

ci: ## Full local CI mirror: lint, typecheck, test, build
	pnpm lint:ci
	pnpm typecheck
	pnpm test
	pnpm build

clean: ## Remove build artifacts and caches
	rm -rf packages/*/dist apps/*/dist .turbo packages/*/.turbo apps/*/.turbo
