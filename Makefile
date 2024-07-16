# Copyright The KCL Authors. All rights reserved.

VERSION := $(shell cat VERSION)

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

tag:
	git tag v${VERSION}
	git push origin v${VERSION}
	gh release create v${VERSION} --draft --generate-notes --title "v${VERSION} Release"
