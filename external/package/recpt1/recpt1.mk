################################################################################
#
# recpt1
#
################################################################################

RECPT1_VERSION = fd64ce07b285a182b64a92f33a9549c0fa951be5
RECPT1_SITE = $(call github,stz2012,recpt1,$(RECPT1_VERSION))
RECPT1_LICENSE = GPL-3.0
RECPT1_LICENSE_FILES = recpt1/COPYING
RECPT1_SUBDIR = recpt1
RECPT1_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBARIB25),y)
RECPT1_CONF_OPTS += --enable-b25
RECPT1_DEPENDENCIES += libarib25
else
RECPT1_CONF_OPTS += --disable-b25
endif

$(eval $(autotools-package))
