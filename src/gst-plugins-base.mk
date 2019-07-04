# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-base
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-plugins-base.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.0
$(PKG)_CHECKSUM := 4093aa7b51e28fb24dfd603893fead8d1b7782f088b05ed0f22a21ef176fb5ae
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib gstreamer liboil libxml2 ogg opus pango theora vorbis dlfcn-win32

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-base/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-examples \
        --disable-opengl \
        --disable-gles2 \
        --disable-egl \
        --disable-wgl \
        --disable-glx \
        --disable-cocoa \
        --disable-x11 \
        --disable-wayland \
        --disable-dispmanx \
        --disable-encoding \
        --disable-videoconvert \
        --disable-videotestsrc \
        --disable-videorate \
        --disable-videoscale \
        --disable-x \
        --disable-xvideo \
        --disable-xshm \
        --disable-alsa \
        --disable-cdparanoia \
        --disable-gl \
        --disable-libvisual \
        --disable-theora \
        --enable-app \
        --enable-audioconvert \
        --enable-gio \
        --enable-playback \
        --enable-audioresample \
        --enable-volume \
        --enable-ogg \
        --enable-opus \
        --enable-vorbis

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # some .dlls are installed to lib - no obvious way to change
    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0'
        mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/'
    )
endef
