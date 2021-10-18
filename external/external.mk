include $(sort $(wildcard $(BR2_EXTERNAL_RASPI_PATH)/package/*/*.mk))

# Workaround: Raspberry Pi Device Tree Overlay
define RPI_FIRMWARE_INSTALL_KERNEL_DTB_OVERLAYS
	for dtb in $(LINUX_DIR)/arch/$(KERNEL_ARCH)/boot/dts/overlays/*.dtb*; do \
		$(INSTALL) -D -m 0644 $${dtb} $(BINARIES_DIR)/rpi-firmware/overlays/$${dtb##*/} || exit 1; \
	done
endef
LINUX_POST_INSTALL_IMAGES_HOOKS += RPI_FIRMWARE_INSTALL_KERNEL_DTB_OVERLAYS
