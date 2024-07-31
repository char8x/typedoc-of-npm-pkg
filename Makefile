SHELL=/bin/bash

GOT_VERSION=v14.4.2
GOT_REPO=https://github.com/sindresorhus/got.git
REPO_DIR=got

generate-doc:
	@if [ -d "$(REPO_DIR)" ]; then \
		rm -rf $(REPO_DIR); \
	fi
	git clone --depth 1 --branch $(GOT_VERSION) -- $(GOT_REPO) $(REPO_DIR)
	@cd $(REPO_DIR) && npm i
	@cd $(REPO_DIR) && npx typedoc --out '../docs' --name "got - $(GOT_VERSION)" source/index.ts

serve-doc:
	@python3 -m http.server --bind 0.0.0.0 8080 --directory docs/

clean:
	rm -rf $(REPO_DIR)

.PHONY: generate-doc serve-doc clean
