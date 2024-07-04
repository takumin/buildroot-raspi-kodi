################################################################################
#
# accountsservice
#
################################################################################

ACCOUNTSSERVICE_VERSION = 23.13.9
ACCOUNTSSERVICE_SOURCE = accountsservice-$(ACCOUNTSSERVICE_VERSION).tar.xz
ACCOUNTSSERVICE_SITE = https://www.freedesktop.org/software/accountsservice
ACCOUNTSSERVICE_LICENSE = GPL-3.0+
ACCOUNTSSERVICE_LICENSE_FILES = COPYING
ACCOUNTSSERVICE_CPE_ID_VENDOR = freedesktop
ACCOUNTSSERVICE_INSTALL_STAGING = YES

ACCOUNTSSERVICE_DEPENDENCIES = \
	host-pkgconf \
	host-vala \
	dbus \
	gobject-introspection \
	libglib2 \
	polkit \
	python3

$(eval $(meson-package))
