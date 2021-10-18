################################################################################
#
# recdvb
#
################################################################################

RECDVB_VERSION = 1.3.3
RECDVB_SOURCE = recdvb-$(RECDVB_VERSION).tgz
RECDVB_SITE = http://www13.plala.or.jp/sat/recdvb
RECDVB_LICENSE = GPL-3.0
RECDVB_LICENSE_FILES = COPYING
RECDVB_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBARIB25),y)
RECDVB_CONF_OPTS += --enable-b25
RECDVB_DEPENDENCIES += libarib25
else
RECDVB_CONF_OPTS += --disable-b25
endif

$(eval $(autotools-package))
