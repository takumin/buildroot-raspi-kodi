################################################################################
#
# gdm
#
################################################################################

GDM_VERSION_MAJOR = 45
GDM_VERSION = $(GDM_VERSION_MAJOR).0.1
GDM_SOURCE = gdm-$(GDM_VERSION).tar.xz
GDM_SITE = https://download.gnome.org/sources/gdm/$(GDM_VERSION_MAJOR)
GDM_LICENSE = GPL-2.0
GDM_LICENSE_FILES = COPYING
GDM_CPE_ID_VENDOR = gnome
GDM_INSTALL_STAGING = YES

GDM_DEPENDENCIES = \
	host-pkgconf \
	accountsservice \
	libcanberra \
	libglib2 \
	libgtk3 \
	libgudev \
	libxcb \
	linux-pam \
	systemd \
	udev \
	xlib_libX11 \
	xlib_libXau

ifneq ($(BR2_PACKAGE_GDM_INITIAL_VT),)
GDM_CONF_OPTS += -Dinitial-vt=$(BR2_PACKAGE_GDM_INITIAL_VT)
endif

ifeq ($(BR2_PACKAGE_GDM_IPV6),y)
GDM_CONF_OPTS += -Dipv6=true
else
GDM_CONF_OPTS += -Dipv6=false
endif

ifeq ($(BR2_PACKAGE_GDM_XSESSION),y)
GDM_CONF_OPTS += -Dgdm-xsession=true
else
GDM_CONF_OPTS += -Dgdm-xsession=false
endif

ifeq ($(BR2_PACKAGE_KEYUTILS),y)
GDM_DEPENDENCIES += keyutils
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
GDM_CONF_OPTS += -Dselinux=enabled
GDM_DEPENDENCIES += libselinux
else
GDM_CONF_OPTS += -Dselinux=disabled
endif

ifeq ($(BR2_PACKAGE_AUDIT),y)
GDM_CONF_OPTS += -Dlibaudit=enabled
GDM_DEPENDENCIES += audit
else
GDM_CONF_OPTS += -Dlibaudit=disabled
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXDMCP),y)
GDM_CONF_OPTS += -Dxdmcp=enabled
GDM_DEPENDENCIES += xlib_libXdmcp
else
GDM_CONF_OPTS += -Dxdmcp=disabled
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER),y)
GDM_DEPENDENCIES += xserver_xorg-server
endif

ifeq ($(BR2_PACKAGE_XWAYLAND),y)
GDM_CONF_OPTS += -Dwayland-support=true
GDM_DEPENDENCIES += xwayland
else
GDM_CONF_OPTS += -Dwayland-support=false
endif

define GDM_INSTALL_PAM_SYSTEM_CONFIG
	$(INSTALL) -m 0644 -D $(GDM_PKGDIR)/system-account.pam \
		$(TARGET_DIR)/etc/pam.d/system-account
	$(INSTALL) -m 0644 -D $(GDM_PKGDIR)/system-auth.pam \
		$(TARGET_DIR)/etc/pam.d/system-auth
	$(INSTALL) -m 0644 -D $(GDM_PKGDIR)/system-session.pam \
		$(TARGET_DIR)/etc/pam.d/system-session
	$(INSTALL) -m 0644 -D $(GDM_PKGDIR)/system-password.pam \
		$(TARGET_DIR)/etc/pam.d/system-password
endef

GDM_CONF_OPTS += -Ddefault-pam-config=lfs
GDM_POST_BUILD_HOOKS += GDM_INSTALL_PAM_SYSTEM_CONFIG

define GDM_USERS
	gdm -1 gdm -1 * /var/lib/gdm - - GNOME Display Manager
endef

define GDM_PERMISSIONS
	/var/lib/gdm d 711 gdm gdm - - - - -
endef

$(eval $(meson-package))
