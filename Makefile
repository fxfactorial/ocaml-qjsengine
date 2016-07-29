# OASIS_START
# DO NOT EDIT (digest: a3c674b4239234cbbe53afe090018954)

SETUP = ocaml setup.ml

build: setup.data
	$(SETUP) -build $(BUILDFLAGS)

doc: setup.data build
	$(SETUP) -doc $(DOCFLAGS)

test: setup.data build
	$(SETUP) -test $(TESTFLAGS)

all:
	$(SETUP) -all $(ALLFLAGS)

install: setup.data
	$(SETUP) -install $(INSTALLFLAGS)

uninstall: setup.data
	$(SETUP) -uninstall $(UNINSTALLFLAGS)

reinstall: setup.data
	$(SETUP) -reinstall $(REINSTALLFLAGS)

clean:
	$(SETUP) -clean $(CLEANFLAGS)

distclean:
	$(SETUP) -distclean $(DISTCLEANFLAGS)

setup.data:
	$(SETUP) -configure $(CONFIGUREFLAGS)

configure:
	$(SETUP) -configure $(CONFIGUREFLAGS)

.PHONY: build doc test all install uninstall reinstall clean distclean configure

# OASIS_STOP

os := $(shell uname -s)
osx_path := /usr/local/opt/qt5/lib/pkgconfig

trusty_path := /opt/qt57/lib/pkgconfig

ifeq (${os}, Darwin)
  ccopts := $(shell PKG_CONFIG_PATH=${osx_path} pkg-config \
--cflags ${osx_path}/Qt5Core.pc ${osx_path}/Qt5Qml.pc)

  cclibs := $(shell PKG_CONFIG_PATH=${osx_path} pkg-config \
--libs ${osx_path}/Qt5Core.pc ${osx_path}/Qt5Qml.pc)
else
  ccopts := $(shell PKG_CONFIG_PATH=${trusty_path} pkg-config \
--cflags ${trusty_path}/Qt5Core.pc ${trusty_path}/Qt5Qml.pc)
  cclibs := $(shell PKG_CONFIG_PATH=${osx_path} pkg-config \
--libs ${trusty_path}/Qt5Core.pc ${trusty_path}/Qt5Qml.pc)
endif

prepare_oasis:
	@sed -i '' -e 's|$${ccopts}|${ccopts}|' _oasis
	@sed -i '' -e 's|$${cclibs}|${cclibs}|' _oasis
