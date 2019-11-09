# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pe-parse
$(PKG)_WEBSITE  := https://github.com/trailofbits/pe-parse
$(PKG)_DESCR    := Principled, lightweight C/C++ PE parser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d2f74fa
$(PKG)_CHECKSUM := 39d1f36f71e7a29b2b49d6e6dae0729887358cfa2cf82c18065df470f3420b50
$(PKG)_GH_CONF  := trailofbits/pe-parse/branches/master
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc

# unpack in pe-util for native and cross build
$(PKG)_DEPS_$(BUILD)  :=
$(PKG)_BUILD_$(BUILD) :=

define $(PKG)_UPDATE
    echo 'Updates for package $(PKG) is disabled.' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    # build and install the cross-library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_COMMAND_LINE_TOOLS=OFF \
        -DCMAKE_CXX_FLAGS='-Wno-error=redundant-decls -Wno-error=ignored-qualifiers'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # test cmake find_package() example
    mkdir '$(BUILD_DIR).cmake'
    cd '$(BUILD_DIR).cmake' && $(TARGET)-cmake '$(SOURCE_DIR)/examples/peaddrconv'
    $(MAKE) -C '$(BUILD_DIR).cmake' -j '$(JOBS)'
    $(INSTALL) -m755 '$(BUILD_DIR).cmake/peaddrconv.exe' '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef
