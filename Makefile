.PHONY: build test lint run fmt vet

BINARY   := afia-gateway
VERSION  := $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS  := -ldflags "-s -w -X main.version=$(VERSION)"

build:
	go build $(LDFLAGS) -o bin/$(BINARY) ./cmd/gateway

test:
	go test -race ./...

lint:
	golangci-lint run ./...

run:
	go run ./cmd/gateway

fmt:
	gofmt -w .

vet:
	go vet ./...
