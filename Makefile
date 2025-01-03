# Makefile for building the Go CLI application
BINARY_NAME=mxlint

# Go related variables
ifeq ($(OS),Windows_NT)
    GOBASE=$(shell cd)
    RM=del /Q
    GOBIN=$(GOBASE)\bin
    GOPKG=$(GOBASE)\cmd\$(BINARY_NAME)
else
    GOBASE=$(shell pwd)
    RM=rm -f
    GOBIN=$(GOBASE)/bin
    GOPKG=$(GOBASE)/cmd/$(BINARY_NAME)
endif

# Go commands
GOBUILD=go build
GOCLEAN=go clean
GOTEST=go test
GOGET=go get


# Build targets
all: clean deps test build-macos build-windows build-macos-arm64

windows: clean deps test build-windows

# Build for macOS
build-macos:
	@echo "Building for macOS amd64..."
	@GOOS=darwin GOARCH=amd64 $(GOBUILD) -o $(GOBIN)/$(BINARY_NAME)-darwin-amd64 $(GOPKG)

build-macos-arm64:
	@echo "Building for macOS arm64..."
	@GOOS=darwin GOARCH=arm64 $(GOBUILD) -o $(GOBIN)/$(BINARY_NAME)-darwin-arm64 $(GOPKG)

# Build for Windows
build-windows:
	@echo "Building for Windows amd64..."
ifeq ($(OS),Windows_NT)
	@set GOOS=windows
	@set GOARCH=amd64
	@$(GOBUILD) -o $(GOBIN)\$(BINARY_NAME)-windows-amd64.exe $(GOPKG)
else
    @GOOS=windows GOARCH=amd64 $(GOBUILD) -o $(GOBIN)/$(BINARY_NAME)-windows-amd64.exe $(GOPKG)
endif

# Clean up binaries
clean:
	@echo "Cleaning..."
	@$(GOCLEAN)
	@if exist $(GOBIN) $(RM) $(GOBIN)\$(BINARY_NAME)*

# Run tests
test:
	@echo "Running tests"
	@$(GOTEST) -v ./...

# Fetch dependencies
deps:
	@echo "Fetching dependencies"
	@go mod tidy