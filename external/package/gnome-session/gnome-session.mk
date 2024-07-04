################################################################################
#
# gnome-session
#
################################################################################

GNOME_SESSION_VERSION_MAJOR = 45
GNOME_SESSION_VERSION = $(GNOME_SESSION_VERSION_MAJOR).0
GNOME_SESSION_SOURCE = gnome-session-$(GNOME_SESSION_VERSION).tar.xz
GNOME_SESSION_SITE = https://download.gnome.org/sources/gnome-session/$(GNOME_SESSION_VERSION_MAJOR)
GNOME_SESSION_LICENSE = GPL-2.0
GNOME_SESSION_LICENSE_FILES = COPYING
GNOME_SESSION_CPE_ID_VENDOR = gnome
GNOME_SESSION_INSTALL_STAGING = YES

# TODO: gnome-desktop-3.0
GNOME_SESSION_DEPENDENCIES = \
	host-pkgconf \
	json-glib \
	libglib2 \
	libgtk3 \
	xlib_libICE \
	xlib_libSM \
	xlib_libX11 \
	xlib_xtrans

$(eval $(meson-package))
