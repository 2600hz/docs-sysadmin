ROOT = $(shell readlink -f .)
DOCS_ROOT=$(ROOT)/doc/mkdocs

docs:
	@$(ROOT)/scripts/validate_mkdocs.py
	@cp $(DOCS_ROOT)/mkdocs.yml $(DOCS_ROOT)/mkdocs.local.yml
	@sed -i 's/doc\///g' $(DOCS_ROOT)/mkdocs.local.yml
	@echo "site_dir: '$(ROOT)/site'\ndocs_dir: '$(ROOT)/doc'\n" >> $(DOCS_ROOT)/mkdocs.local.yml
	@cp $(DOCS_ROOT)/index.md $(ROOT)/doc/index.md
	@mkdocs build -f $(DOCS_ROOT)/mkdocs.local.yml -c -q

docs-serve: docs
	@mkdocs serve -f $(DOCS_ROOT)/mkdocs.local.yml
