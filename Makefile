#!make

CWD ?= $(shell pwd)
BIN ?= dist.sh
PREFIX ?= /usr/local

install: uninstall
	@cp dist.sh $(PREFIX)/bin/$(BIN)

uninstall:
	@rm -f $(PREFIX)/bin/$(BIN)

link: uninstall
	@ln -s $(CWD)/dist.sh $(PREFIX)/bin/$(BIN)

.PHONY: test
test:
	@cd test/fixtures && ../../dist.sh

push:
	@git add .
	@git commit -am "new release"
	@git push

dev: init

init: editorconfig

editorconfig:
	curl -so .editorconfig https://editorconfig.javanile.org/lib/shell
