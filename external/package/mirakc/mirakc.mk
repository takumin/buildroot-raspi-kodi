################################################################################
#
# mirakc
#
################################################################################

MIRAKC_VERSION = 1.0.13
MIRAKC_SITE = $(call github,mirakc,mirakc,$(MIRAKC_VERSION))
MIRAKC_LICENSE = Apache-2.0 and MIT
MIRAKC_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

MIRAKC_DEPENDENCIES = host-rustc host-pkgconf host-jq libfuse3

MIRAKC_CARGO_ENV = \
	CARGO_HOME=$(HOST_DIR)/share/cargo \
	PKG_CONFIG_ALLOW_CROSS=1

MIRAKC_BIN_DIR = \
	target/$(RUSTC_TARGET_NAME)/$(if $(BR2_ENABLE_DEBUG),debug,release)

MIRAKC_CARGO_OPTS = \
	$(if $(BR2_ENABLE_DEBUG),,--release) \
	--target=$(RUSTC_TARGET_NAME) \
	--manifest-path=$(@D)/Cargo.toml

define MIRAKC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MIRAKC_CARGO_ENV) \
		cargo build $(MIRAKC_CARGO_OPTS)
	cat $(@D)/resources/strings.yml > \
		$(MIRAKC_BUILDDIR)/$(MIRAKC_BIN_DIR)/strings.yml
	cat $(@D)/resources/mirakurun.openapi.json | jq -Mc '.' > \
		$(MIRAKC_BUILDDIR)/$(MIRAKC_BIN_DIR)/mirakurun.openapi.json
endef

define MIRAKC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 \
		$(MIRAKC_BUILDDIR)/$(MIRAKC_BIN_DIR)/mirakc \
		$(TARGET_DIR)/usr/bin/mirakc
	$(INSTALL) -D -m 0755 \
		$(MIRAKC_BUILDDIR)/$(MIRAKC_BIN_DIR)/mirakc-timeshift-fs \
		$(TARGET_DIR)/usr/bin/mirakc-timeshift-fs

	mkdir -p $(TARGET_DIR)/etc/mirakc
	$(INSTALL) -D -m 0644 \
		$(MIRAKC_BUILDDIR)/$(MIRAKC_BIN_DIR)/strings.yml \
		$(TARGET_DIR)/etc/mirakc/strings.yml
	$(INSTALL) -D -m 0644 \
		$(MIRAKC_BUILDDIR)/$(MIRAKC_BIN_DIR)/mirakurun.openapi.json \
		$(TARGET_DIR)/etc/mirakurun.openapi.json

	$(INSTALL) -D -m 0644 \
		$(MIRAKC_PKGDIR)/config.yml \
		$(TARGET_DIR)/etc/mirakc/config.yml
endef

define MIRAKC_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 \
		$(MIRAKC_PKGDIR)/mirakc.service \
		$(TARGET_DIR)/usr/lib/systemd/system/mirakc.service
endef

$(eval $(generic-package))
