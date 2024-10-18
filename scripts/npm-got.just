set quiet

NPM_VERSION := "v14.4.2"
NPM_REPO := "https://github.com/sindresorhus/got.git"
NPM_PKG_NAME := "got"

CLONE_REPO_DIR := parent_directory(justfile_directory()) / "repo" / NPM_PKG_NAME
DOC_DIR := parent_directory(justfile_directory()) / "docs" / NPM_PKG_NAME / NPM_VERSION

test-var:
  #echo {{parent_directory(justfile_directory())}}
  #echo {{justfile_directory()}}
  echo {{DOC_DIR}}
  echo {{CLONE_REPO_DIR}}

ensure-dir:
	mkdir -p {{DOC_DIR}}
	mkdir -p {{CLONE_REPO_DIR}}

remove-git-repo:
	if [ -d "{{CLONE_REPO_DIR}}" ]; then \
		rm -rf {{CLONE_REPO_DIR}}; \
	fi

clone-repo:
  git clone --depth 1 --branch {{NPM_VERSION}} -- {{NPM_REPO}} {{CLONE_REPO_DIR}}

install-deps:
  cd {{CLONE_REPO_DIR}} && npm i

generate-docs:
  cd {{CLONE_REPO_DIR}} && npx --yes typedoc --out {{DOC_DIR}} --name "{{NPM_PKG_NAME}} - {{NPM_VERSION}}" source/index.ts

build:
  just -f {{justfile()}} remove-git-repo clone-repo install-deps generate-docs clean

serve-doc:
	python3 -m http.server --bind 0.0.0.0 8080 --directory {{DOC_DIR}}

clean:
	rm -rf {{CLONE_REPO_DIR}}
