run:
	npm run start

update-deps:
	npm install

run-i18n:
	npm run build && npx http-server ./build

check-link:
	go run ./hack/linkcheck.go

version:
	npm run docusaurus docs:version 0.4.6

# Edit your API_KEY in .env before run `make algolia` for the `kcl-lang` index.
algolia:
	docker run -it --env-file=.env -e "CONFIG=$(cat ./config.json | jq -r tostring)" algolia/docsearch-scraper
