unexport CPATH
unexport C_INCLUDE_PATH
unexport CPLUS_INCLUDE_PATH
unexport PKG_CONFIG_PATH
unexport CMAKE_MODULE_PATH
unexport CCACHE_PATH
unexport LD_LIBRARY_PATH
unexport LD_RUN_PATH
unexport UNZIP

export LC_ALL = C
export DL_DIR = $(HOME)/.buildroot/dl
export CCACHE_DIR = $(HOME)/.buildroot/ccache

BUILD_DIR    = /tmp/buildroot-raspi-kodi-build
EXTERNAL_DIR = $(CURDIR)/external

################################################################################
#
# default
#
################################################################################

.PHONY: default
default: build

################################################################################
#
# defconfig
#
################################################################################

.PHONY: defconfig
defconfig:
ifeq ("$(wildcard $(BUILD_DIR)/.config)","")
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) raspberrypi4_64_kodi_defconfig
endif

################################################################################
#
# download
#
################################################################################

.PHONY: defconfig
download: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) source

################################################################################
#
# menuconfig
#
################################################################################

.PHONY: menuconfig
menuconfig: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) menuconfig

.PHONY: linux-menuconfig
linux-menuconfig: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) linux-menuconfig

.PHONY: busybox-menuconfig
busybox-menuconfig: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) busybox-menuconfig

.PHONY: barebox-menuconfig
barebox-menuconfig: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) barebox-menuconfig

.PHONY: uboot-menuconfig
uboot-menuconfig: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) uboot-menuconfig

################################################################################
#
# build
#
################################################################################

.PHONY: build
build: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR)

linux-rebuild: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) linux-rebuild

busybox-rebuild: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) busybox-rebuild

barebox-rebuild: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) barebox-rebuild

uboot-rebuild: defconfig
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) uboot-rebuild

################################################################################
#
# clean
#
################################################################################

clean:
ifneq ("$(wildcard $(BUILD_DIR)/.config)","")
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) clean
endif

linux-dirclean:
ifneq ("$(wildcard $(BUILD_DIR)/.config)","")
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) linux-dirclean
endif

busybox-dirclean:
ifneq ("$(wildcard $(BUILD_DIR)/.config)","")
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) busybox-dirclean
endif

barebox-dirclean:
ifneq ("$(wildcard $(BUILD_DIR)/.config)","")
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) barebox-dirclean
endif

uboot-dirclean:
ifneq ("$(wildcard $(BUILD_DIR)/.config)","")
	@$(MAKE) -C buildroot O=$(BUILD_DIR) BR2_EXTERNAL=$(EXTERNAL_DIR) uboot-dirclean
endif

distclean:
	@rm -fr $(BUILD_DIR)
