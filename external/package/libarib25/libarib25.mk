################################################################################
#
# libarib25
#
################################################################################

LIBARIB25_VERSION = ab6afa7c7f4022af7dda7976489ec7a0716efb9a
LIBARIB25_SITE = $(call github,stz2012,libarib25,$(LIBARIB25_VERSION))
LIBARIB25_LICENSE = Apache-2.0
LIBARIB25_LICENSE_FILES = LICENSE
LIBARIB25_DEPENDENCIES = pcsc-lite
LIBARIB25_INSTALL_STAGING = YES
LIBARIB25_CONF_OPTS += -DLDCONFIG_EXECUTABLE=""

ifeq ($(BR2_X86_CPU_HAS_AVX2),y)
LIBARIB25_CONF_OPTS += -DUSE_AVX2=ON
else
LIBARIB25_CONF_OPTS += -DUSE_AVX2=OFF
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
LIBARIB25_CONF_OPTS += -DUSE_NEON=ON
else
LIBARIB25_CONF_OPTS += -DUSE_NEON=OFF
endif

define LIBARIB25_INSTALL_STREAM_COMMAND
	$(INSTALL) -D -m 0755 $(LIBARIB25_PKGDIR)/arib-b25-stream \
		$(TARGET_DIR)/usr/bin/arib-b25-stream
endef
LIBARIB25_POST_INSTALL_TARGET_HOOKS += LIBARIB25_INSTALL_STREAM_COMMAND

$(eval $(cmake-package))
