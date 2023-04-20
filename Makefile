.PHONY: run
run:
	npm run start

.PHONY: install
install:
	npm install

.PHONY: run-i18n
run-i18n:
	npm run build && npx http-server ./build

.PHONY: check-link
check-link:
	go run ./hack/linkcheck.go

.PHONY: version
version:
	npm run docusaurus docs:version $(shell cat VERSION)

.PHONY: algolia
# Edit your API_KEY in .env before run `make algolia` for the `kcl-lang` index.
algolia:
	docker run -it --env-file=.env -e "CONFIG=$(cat ./config.json | jq -r tostring)" algolia/docsearch-scraper
