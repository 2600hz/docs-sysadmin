ROOT = $(shell readlink -f .)
DOCS_ROOT=$(ROOT)/doc/mkdocs

include make/splchk.mk

docs: docs-report docs-setup docs-build

docs-report:
	@$(ROOT)/scripts/reconcile_docs_to_index.bash

docs-setup:
	@$(ROOT)/scripts/validate_mkdocs.py
	@$(ROOT)/scripts/setup_docs.bash
	@cp $(DOCS_ROOT)/mkdocs.yml $(DOCS_ROOT)/mkdocs.local.yml
	@mkdir -p $(DOCS_ROOT)/theme
	@if [ -f $(DOCS_ROOT)/theme/global.yml ]; then cat $(DOCS_ROOT)/theme/global.yml >> $(DOCS_ROOT)/mkdocs.local.yml; fi

docs-build:
	@echo "\ntheme: null\ntheme_dir: '$(DOCS_ROOT)/theme'\ndocs_dir: '$(DOCS_ROOT)/docs'\n" >> $(DOCS_ROOT)/mkdocs.local.yml
	@cp $(DOCS_ROOT)/index.md $(ROOT)/doc/index.md
	@mkdocs build -f $(DOCS_ROOT)/mkdocs.local.yml --clean -q --site-dir $(DOCS_ROOT)/site

docs-serve: docs-build
	@mkdocs serve --dev-addr=0.0.0.0:9876 -f $(DOCS_ROOT)/mkdocs.local.yml

docs-clean:
	@rm -rf $(DOCS_ROOT)/site $(DOCS_ROOT)/docs $(DOCS_ROOT)/mkdocs.local.yml
