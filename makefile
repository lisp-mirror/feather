# Hey Emacs, this is a -*- Mode: makefile-*-

# Binary name
TARGET = feather
##       ^^^^^^^ CHANGE THIS!!

# Quicklisp system to load
QL_SYSTEM = feather
##          ^^^^^^^ CHANGE THIS!!

# Loading systems with quicklisp without having quicklisp in the image:
# http://stackoverflow.com/questions/18917067/how-to-use-buildapp-in-combination-with-quicklisp

# Flags for manifest build
MANIFEST_FLAGS =  --no-init 
MANIFEST_FLAGS += --batch 
MANIFEST_FLAGS += --load $(SRCDIR)/prep-quicklisp.lisp
MANIFEST_FLAGS += --eval '(ql:quickload :qlot)'
MANIFEST_FLAGS += --eval '(qlot:install :$(QL_SYSTEM))'
MANIFEST_FLAGS += --eval '(qlot:quickload :$(QL_SYSTEM))'
MANIFEST_FLAGS += --eval '(qlot:with-local-quicklisp (:$(QL_SYSTEM)) (ql:write-asdf-manifest-file \#P"$(MANIFEST)" :if-exists :supersede :exclude-local-projects nil))'
MANIFEST_FLAGS += --eval '(format t "~%***** $(QL_SYSTEM) was loaded from~%~A~%*****~%" (asdf:system-source-file (asdf:find-system :$(QL_SYSTEM))))'
MANIFEST_FLAGS += --eval '(quit)'

# Buildapp settings
B_FLAGS =  --output $(BUILDDIR)/$(TARGET)
B_FLAGS += --logfile $(BUILDLOG)
B_FLAGS += --manifest-file $(MANIFEST)
B_FLAGS += --asdf-path $(CURDIR)/
B_FLAGS += --asdf-tree $(SRCDIR)/
B_FLAGS += --load-system $(QL_SYSTEM)
B_FLAGS += --entry $(QL_SYSTEM):main
B_FLAGS += --eval '(format t "~%***** $(QL_SYSTEM) was loaded from~%~A~%*****~%" (asdf:system-source-file (asdf:find-system :$(QL_SYSTEM))))'

# Flags for DB migration
QL_MIGRATE_SYSTEM = $(QL_SYSTEM)/migrate
MIGRATE_FLAGS =  --no-init 
MIGRATE_FLAGS += --batch 
MIGRATE_FLAGS += --load $(SRCDIR)/prep-quicklisp.lisp
MIGRATE_FLAGS += --eval '(ql:quickload :qlot)'
MIGRATE_FLAGS += --eval '(qlot:install :$(QL_MIGRATE_SYSTEM))'
MIGRATE_FLAGS += --eval '(qlot:quickload :$(QL_MIGRATE_SYSTEM))'
MIGRATE_FLAGS += --eval '(format t "~%***** $(QL_MIGRATE_SYSTEM) was loaded from~%~A~%*****~%" (asdf:system-source-file (asdf:find-system :$(QL_MIGRATE_SYSTEM))))'
MIGRATE_FLAGS += --eval '($(QL_SYSTEM)-migrate:upgrade)'
MIGRATE_FLAGS += --eval '(quit)'

# Location: Source files
SRCDIR = $(CURDIR)/src

# Location: Build output
BUILDDIR = $(CURDIR)/build

# Location: Temp output
TMPDIR = $(BUILDDIR)/tmp

# Location: Manifest
MANIFEST = $(BUILDDIR)/quicklisp-manifest.txt

# Location: Build log
BUILDLOG = $(BUILDDIR)/build-log.txt

# Location: Installation path of application files
DESTDIR = /opt/$(TARGET)

# Location: Symlink in path
EXECDIR = /usr/local/bin

# File name of the binary
BINNAME = $(TARGET)_$(shell date +%Y-%m-%d)

all: $(TARGET)

$(TARGET): build_manifest build

build_manifest: check_root
	mkdir -p $(BUILDDIR)
	$(LISP) $(MANIFEST_FLAGS)

# NB !!
# BUILDAPP must use the quicklisp libraries as compiled by build_manifest
# because Quicklisp can compile some libs which Buildapp can't. That prevents
# the application from being built.
# BUILDAPP must still recompile the project's code. Just to be sure.
build: check_root
	mkdir -p $(BUILDDIR)
	$(FIND) $(CURDIR)/src/ -exec touch {} \;
	$(BUILDAPP) $(B_FLAGS) 

.PHONY: install
install:
# Systemd config
	cp $(CURDIR)/infra/$(TARGET).service /lib/systemd/system/
	systemctl daemon-reload
# Feather binary
	install -C -D -m 755 -o wimpie -g wimpie $(BUILDDIR)/$(TARGET) $(DESTDIR)/bin/$(BINNAME)
	ln -sf $(DESTDIR)/bin/$(BINNAME) $(EXECDIR)/$(TARGET)

.PHONY: migrate
migrate:
	$(LISP) $(MIGRATE_FLAGS)

.PHONY: clean
clean: 
	-rm $(BUILDDIR)/*
	-rm $(MANIFEST) $(BUILDLOG)

cleanfasl:
	$(LISP) --no-init --batch --load $(SRCDIR)/prep-quicklisp.lisp --load $(CURDIR)/scripts/clean.lisp --eval '(quit)'

distclean: clean
	-rm -rf ~/.cache/common-lisp/*

check_root:
	@if [ "$(USER)" = "root" ] ; then echo "Don't run this target as root"; exit 1; fi

# Applications
SHELL = /bin/sh
BUILDAPP = buildapp
LISP = ccl
FIND = find
