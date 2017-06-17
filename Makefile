SHELL := /bin/bash -eu -o pipefail

NAME := KeyType
OS   := sierra

.PHONY: build
build:
	@xcodebuild -project KeyType.xcodeproj -target KeyType -configuration Release build

.PHONY: dist
dist:
	@cd build/Release \
		&& zip -r "$(NAME)-$(OS).zip" KeyType.app \
		&& mv "$(NAME)-$(OS).zip" .. \
		&& cd ../..
