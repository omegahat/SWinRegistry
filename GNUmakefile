include VersionInfo

ifdef UNIX

ifndef RHOME
 RHOME=$(R_HOME)
endif

PACKAGE_DIR=/tmp

else
PACKAGE_DIR=$(RHOME)/src/library
PACKAGE_DIR=/tmp
endif

RSCommon.h: $(OMEGA_HOME)/include/Corba/RSCommon.h
	cp $(OMEGA_HOME)/include/Corba/RSCommon.h .

package: RSCommon.h


INSTALL_DIR=${PACKAGE_DIR}/$(PKG_NAME)

include Install/GNUmakefile.admin

C_SOURCE=$(wildcard src/*.[ch] src/*.cpp) RSCommon.h src/Makevars.win
# src/Makefile.win
R_SOURCE=$(wildcard R/*.[RS])
MAN_FILES=$(wildcard man/*.Rd)
INSTALL_DIRS=src man R

DESCRIPTION: DESCRIPTION.in Install/configureInstall.in VersionInfo

DOCS=Docs/howto.html Docs/howto.html

package: DESCRIPTION $(DOCS)
#	@if test -z "${RHOME}" ; then echo "You must specify RHOME" ; exit 1 ; fi
	if test -d $(INSTALL_DIR) ; then rm -fr $(INSTALL_DIR) ; fi
	mkdir $(INSTALL_DIR)
	cp DESCRIPTION $(INSTALL_DIR)
	for i in $(INSTALL_DIRS) ; do \
	   mkdir $(INSTALL_DIR)/$$i ; \
	done
	cp -r $(C_SOURCE) $(INSTALL_DIR)/src
	cp -r $(MAN_FILES) $(INSTALL_DIR)/man
	cp -r $(R_SOURCE) $(INSTALL_DIR)/R
	mkdir $(INSTALL_DIR)/inst
	mkdir $(INSTALL_DIR)/inst/Docs
	if test -n "${DOCS}" ; then cp $(DOCS) $(INSTALL_DIR)/inst/Docs ; fi
	if test -d examples ; then cp -r examples $(INSTALL_DIR)/inst ; fi
	find $(INSTALL_DIR) -name '*~' -exec rm {} \;
#	touch $(INSTALL_DIR)/install.R


PWD=$(shell pwd)

zip: 
	(cd $(RHOME)/library ; zip -r $(ZIP_FILE) $(PKG_NAME); mv $(ZIP_FILE) $(PWD))

tar source: package
	(cd $(INSTALL_DIR)/.. ; tar zcf $(TAR_SRC_FILE) $(PKG_NAME); mv $(TAR_SRC_FILE) $(PWD))

#	(cd $(RHOME)/src/library ; zip -r $(ZIP_SRC_FILE) $(PKG_NAME); mv $(ZIP_SRC_FILE) $(PWD))


binary: package
	(cd $(RHOME)/src/library ; Rcmd build --binary $(PKG_NAME); mv $(ZIP_FILE) $(PWD))

install: package
	(cd $(RHOME)/src/gnuwin32 ; make pkg-$(PKG_NAME))

check: package
	(cd $(RHOME)/src/library ; Rcmd check $(PKG_NAME))

file:
	@echo "${PKG_FILES}"

Docs/%.html: Docs/%.xml
	$(MAKE) -C Docs $(@F)
