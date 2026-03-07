# Makefile for Firefox 3.5.6 Container

REGISTRY_IMAGE = ghcr.io/ksimuk/ff356:latest
DEFAULT_URL = http://192.168.175.5
URL ?= $(DEFAULT_URL)
.PHONY: build run run-local pull help

# Build the Docker image locally
build:
	@echo "Building Docker image: $(REGISTRY_IMAGE)"
	docker build -t $(REGISTRY_IMAGE) .

# Run from GHCR (pulls latest if needed)
run:
	@echo "Running from GHCR: $(REGISTRY_IMAGE)"
	./run.sh $(URL)

# Pull latest image from GHCR
pull:
	@echo "Pulling latest image from GHCR"
	docker pull $(REGISTRY_IMAGE)

# Show help
help:
	@echo "Available targets:"
	@echo "  build     - Build the Docker image locally"
	@echo "  run       - Run Firefox from GHCR image (default)"
	@echo "  pull      - Pull latest image from GHCR"
	@echo "  help      - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make build"
	@echo "  make run"
	@echo "  make run URL=http://example.com"

# Default target
.DEFAULT_GOAL := help
