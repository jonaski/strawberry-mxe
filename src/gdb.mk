# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdb
$(PKG)_WEBSITE  := https://www.gnu.org/software/gdb/
$(PKG)_VERSION  := 10.2
$(PKG)_CHECKSUM := aaa1223d534c9b700a8bec952d9748ee1977513f178727e1bee520ee000b4f29
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 expat libiconv mman-win32 readline zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        $(MXE_DISABLE_DOC_OPTS) \
        --with-system-readline \
        --disable-gdbtk \
        --disable-tui \
        host_configargs="LIBS=\"`$(TARGET)-pkg-config --libs dlfcn` -lmman\"" \
        LDFLAGS='-Wl,--allow-multiple-definition'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' CFLAGS='-D_WIN32_WINNT=0x0600'
    $(INSTALL) -m755 '$(BUILD_DIR)/gdb/gdb.exe'                 '$(PREFIX)/$(TARGET)/bin/'
endef
