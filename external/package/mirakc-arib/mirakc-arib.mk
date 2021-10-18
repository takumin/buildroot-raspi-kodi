################################################################################
#
# mirakc-arib
#
################################################################################

MIRAKC_ARIB_VERSION = 0.16.4
MIRAKC_ARIB_SITE = https://github.com/mirakc/mirakc-arib.git
MIRAKC_ARIB_SITE_METHOD = git
MIRAKC_ARIB_GIT_SUBMODULES = YES
MIRAKC_ARIB_SUPPORTS_IN_SOURCE_BUILD = NO
MIRAKC_ARIB_LICENSE = Apache-2.0 and MIT
MIRAKC_ARIB_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

define MIRAKC_ARIB_VENDOR_PATCHTES
	patch -p0 -E -t -N -d $(MIRAKC_ARIB_SRCDIR)/vendor/spdlog -i $(MIRAKC_ARIB_SRCDIR)/patches/spdlog.patch
	patch -p0 -E -t -N -d $(MIRAKC_ARIB_SRCDIR)/vendor/libisdb -i $(MIRAKC_ARIB_SRCDIR)/patches/LibISDB.patch
endef

MIRAKC_ARIB_POST_PATCH_HOOKS += MIRAKC_ARIB_VENDOR_PATCHTES

MIRAKC_ARIB_CONF_ENV += \
	PKG_CONFIG_LIBDIR="/" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	PKG_CONFIG_SYSTEM_INCLUDE_PATH="/" \
	PKG_CONFIG_SYSTEM_LIBRARY_PATH="/"

MIRAKC_ARIB_MAKE_ENV += \
	PKG_CONFIG_LIBDIR="/" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	PKG_CONFIG_SYSTEM_INCLUDE_PATH="/" \
	PKG_CONFIG_SYSTEM_LIBRARY_PATH="/"

ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
MIRAKC_ARIB_HOST_TRIPLE = $(TOOLCHAIN_EXTERNAL_PREFIX)
else
MIRAKC_ARIB_HOST_TRIPLE = $(GNU_TARGET_NAME)
endif

define MIRAKC_ARIB_CONFIGURE_CMDS
	{ \
		echo 'set(CMAKE_SYSTEM_NAME Linux)'; \
		echo 'set(CMAKE_SYSTEM_PROCESSOR $(BR2_ARCH))'; \
		echo 'set(MIRAKC_ARIB_HOST_TRIPLE $(MIRAKC_ARIB_HOST_TRIPLE))'; \
		echo 'set(CMAKE_C_FLAGS "$(TARGET_CFLAGS)")'; \
		echo 'set(CMAKE_C_FLAGS_DEBUG "")'; \
		echo 'set(CMAKE_C_FLAGS_RELEASE "-DNDEBUG")'; \
		echo 'set(CMAKE_C_COMPILER $(MIRAKC_ARIB_HOST_TRIPLE)-gcc)'; \
		echo 'set(CMAKE_C_COMPILER_TARGET $(MIRAKC_ARIB_HOST_TRIPLE))'; \
		echo 'set(CMAKE_CXX_FLAGS "$(TARGET_CXXFLAGS)")'; \
		echo 'set(CMAKE_CXX_FLAGS_DEBUG "")'; \
		echo 'set(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG")'; \
		echo 'set(CMAKE_CXX_COMPILER $(MIRAKC_ARIB_HOST_TRIPLE)-g++)'; \
		echo 'set(CMAKE_CXX_COMPILER_TARGET $(MIRAKC_ARIB_HOST_TRIPLE))'; \
	} > "$(MIRAKC_ARIB_SRCDIR)/toolchain.cmake"

	mkdir -p "$(MIRAKC_ARIB_BUILDDIR)"

	PATH=$(BR_PATH) $(MIRAKC_ARIB_CONF_ENV) $(BR2_CMAKE) \
		-DCMAKE_BUILD_TYPE=$(if $(BR2_ENABLE_RUNTIME_DEBUG),Debug,Release) \
		-DCMAKE_TOOLCHAIN_FILE="$(MIRAKC_ARIB_SRCDIR)/toolchain.cmake" \
		-DCMAKE_COLOR_MAKEFILE=OFF \
		-DBUILD_DOC=OFF \
		-DBUILD_DOCS=OFF \
		-DBUILD_EXAMPLE=OFF \
		-DBUILD_EXAMPLES=OFF \
		-DBUILD_TEST=OFF \
		-DBUILD_TESTS=OFF \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=$(if $(BR2_STATIC_LIBS),OFF,ON) \
		-S $(MIRAKC_ARIB_SRCDIR) \
		-B $(MIRAKC_ARIB_BUILDDIR) \
		$(CMAKE_QUIET) \
		$(MIRAKC_ARIB_CONF_OPTS)
endef

define MIRAKC_ARIB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MIRAKC_ARIB_MAKE_ENV) $(MAKE) $(MIRAKC_ARIB_MAKE_OPTS) -C $(MIRAKC_ARIB_BUILDDIR) vendor
	$(TARGET_MAKE_ENV) $(MIRAKC_ARIB_MAKE_ENV) $(MAKE) $(MIRAKC_ARIB_MAKE_OPTS) -C $(MIRAKC_ARIB_BUILDDIR)
endef

define MIRAKC_ARIB_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(MIRAKC_ARIB_BUILDDIR)/bin/mirakc-arib $(TARGET_DIR)/usr/bin/mirakc-arib
endef

$(eval $(cmake-package))