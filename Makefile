DEBDEPS=python3-virtualenv
SNAPDEPS=charm
VENVDEPS=charmhelpers charms.reactive flake8

VENV=.venv
BIN=$(VENV)/bin
PYTHON=$(BIN)/python

all: devenv

$(PYTHON):
	virtualenv -p python3 $(VENV)
	$(BIN)/pip install $(VENVDEPS)

.PHONY: build
build: clean
	/snap/bin/charm build

.PHONY: check
check: lint test

.PHONY: clean
clean:
	rm -r $(VENV)

.PHONY: devenv
devenv: $(PYTHON)c

.PHONY: lint
lint: $(PYTHON)
	@$(BIN)/flake8 lib/charms/layer/*.py reactive/*.py tests/*.py

.PHONY: test
test: $(PYTHON)
	@$(PYTHON) tests/test_jujushell.py -v

.PHONY: sysdeps
sysdeps:
	sudo apt install -y $(DEBDEPS)
	sudo snap install $(SNAPDEPS)