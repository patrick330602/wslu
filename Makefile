AUTOMAKE_OPTIONS = foreign
DESTDIR ?=
PREFIX ?= /usr

HEADER = src/wslu-header
OUTPATH = out
MANPATH = docs
OUTMANPATH = out-docs
CURPATH = $(shell pwd)

SOURCES := $(wildcard src/*.sh)
ETCFILES := $(wildcard src/etc/*)
OUTFILES := $(wildcard out/*)
MANFILES := $(wildcard docs/*)
INSTEDEXES := $(wildcard $(DESTDIR)$(PREFIX)/bin/wsl*)
INSTEDMANOS := $(wildcard $(DESTDIR)$(PREFIX)/share/man/man1/wsl*)

DATETMP = $(shell date +%Y-%m-%d)
VERTMP = $(shell cat ./VERSION)

all: doc
	[ -d $(OUTPATH) ] || mkdir $(OUTPATH)
	sed -e 's/VERSIONPLACEHOLDER/'$(VERTMP)'/' -e 's|PREFIXPLACEHOLDER|'$(PREFIX)'|' $(HEADER) > $(HEADER).tmp; \
	for file in $(SOURCES); do \
		cat $(HEADER).tmp $$file > $(OUTPATH)/`basename $$file`; \
		mv $(OUTPATH)/`basename $$file` $(OUTPATH)/`basename $$file .sh`; \
	done
	rm $(HEADER).tmp
	chmod +x $(OUTPATH)/*

install: doc_install res_install
	install -Dm 755 out/* -t $(DESTDIR)$(PREFIX)/bin

uninstall: 
	for f in $(INSTEDEXES); do \
		rm -f $$f; \
	done
	for f in $(INSTEDMANOS); do \
		rm -f $$f; \
	done
	rm -rf $(DESTDIR)$(PREFIX)/share/man/man7/wslu.7.gz
	rm -rf $(DESTDIR)$(PREFIX)/share/wslu

doc:
	[ -d $(OUTMANPATH) ] || mkdir $(OUTMANPATH)
	for file in $(MANFILES); do \
		cp $$file $(OUTMANPATH); \
		sed -e 's/DATEPLACEHOLDER/'$(DATETMP)'/' -e 's/VERSIONPLACEHOLDER/'$(VERTMP)'/' $(OUTMANPATH)/`basename $$file` > $(OUTMANPATH)/`basename $$file`.tmp; \
		mv $(OUTMANPATH)/`basename $$file`.tmp $(OUTMANPATH)/`basename $$file`; \
		gzip -f -q $(OUTMANPATH)/`basename $$file`; \
	done

doc_install:
	install -Dm 644 out-docs/*.1.gz -t $(DESTDIR)$(PREFIX)/share/man/man1
	install -Dm 644 out-docs/*.7.gz -t $(DESTDIR)$(PREFIX)/share/man/man7

res_install:
	install -Dm 644 src/etc/*.vbs -t $(DESTDIR)$(PREFIX)/share/wslu
	install -Dm 644 src/etc/*.ps1 -t $(DESTDIR)$(PREFIX)/share/wslu
	install -Dm 644 src/etc/*.ico -t $(DESTDIR)$(PREFIX)/share/wslu
	install -Dm 755 src/etc/*.sh -t $(DESTDIR)$(PREFIX)/share/wslu
	install -Dm 644 src/etc/*.desktop $(DESTDIR)$(PREFIX)/share/wslu

clean:
	rm -rf $(OUTPATH)
	rm -rf $(OUTMANPATH)

test: 
	bats -r tests

coverage: 
	kcov --include-path="./src,./out" ./tests/coverage bats -r tests
