# Copyright 2023 The KCL Authors. All rights reserved.
VERSION := $(shell cat VERSION)

PROJECT_NAME = kcl-lang

PWD:=$(shell pwd)

BUILD_IMAGE:=kcllang/kcl-builder

# export DOCKER_DEFAULT_PLATFORM=linux/amd64
# or
# --platform linux/amd64

RUN_IN_DOCKER:=docker run -it --rm
RUN_IN_DOCKER+=-v ~/.ssh:/root/.ssh
RUN_IN_DOCKER+=-v ${PWD}:/root/kcl
RUN_IN_DOCKER+=-w /root/kcl ${BUILD_IMAGE}

.PHONY: run
run:
	npm run start

.PHONY: install
install:
	npm install

.PHONY: build
build:
	npm run build && npx http-server ./build

.PHONY: check-link
check-link:
	go run ./hack/linkcheck.go

.PHONY: version
version:
	npm run docusaurus docs:version $(shell cat VERSION)

.PHONY: test
fmt:
	npm run format

.PHONY: test
test:
	./examples/test.sh

.PHONY: translations
translations:
	npm run docusaurus write-translations

.PHONY: algolia
# Edit your API_KEY in .env before run `make algolia` for the `kcl-lang` index.
algolia:
	docker run -it --env-file=.env -e "CONFIG=$(cat ./config.json | jq -r tostring)" algolia/docsearch-scraper

# ----------------
# Docker
# ----------------

.PHONY: sh-in-docker
sh-in-docker:
	${RUN_IN_DOCKER} bash

tag:
	git tag v${VERSION}
	git push origin v${VERSION}
	gh release create v${VERSION} --draft --generate-notes --title "v${VERSION} Release"
