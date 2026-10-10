COMPOSE := docker compose -f deploy/docker-compose.yml $(if $(wildcard .env),--env-file .env)
PRODUCT_PORT ?= 8081

.PHONY: help up watch down logs ps test test-integration vet fmt build run-product health migrate seed

help:
	@echo Perintah yang tersedia:
	@echo   make up           - jalankan semua service (Docker)
	@echo   make watch        - jalankan + build ulang otomatis saat kode berubah
	@echo   make down         - hentikan semua service
	@echo   make logs         - lihat log semua service
	@echo   make ps           - status container
	@echo   make test         - unit test
	@echo   make vet          - go vet
	@echo   make fmt          - format kode
	@echo   make build        - build semua package Go
	@echo   make run-product  - jalankan product service tanpa Docker
	@echo   make health       - cek /healthz product service

up:
	$(COMPOSE) up -d --build

watch:
	$(COMPOSE) watch

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

test:
	go test ./...

test-integration:
	@echo Belum ada integration test - lihat Roadmap Fase 1.

vet:
	go vet ./...

fmt:
	go fmt ./...

build:
	go build ./...

run-product:
	go run ./services/product

health:
	curl -fsS http://localhost:$(PRODUCT_PORT)/healthz

migrate:
	@echo Belum ada migrasi - lihat Roadmap Fase 1.

seed:
	@echo Belum ada data seed - lihat Roadmap Fase 1.
