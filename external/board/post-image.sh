#!/bin/bash
# vim: set noet :

set -eu

mkdir -p "${BINARIES_DIR}/pxeboot"

{
	echo 'start_file=start.elf'
	echo 'fixup_file=fixup.dat'
	echo 'arm_64bit=1'
	echo 'kernel=u-boot.bin'
	echo 'force_turbo=1'
	echo 'device_tree_address=0x02000000'
	echo 'dtoverlay=miniuart-bt'
	echo 'dtoverlay=vc4-kms-v3d-pi4,cma-512'
	echo 'dtoverlay=rpivid-v4l2'
	echo 'gpu_mem=256'
	echo 'max_framebuffers=2'
	echo 'hdmi_ignore_cec_init=1'
	echo 'disable_overscan=1'
	echo 'disable_fw_kms_setup=1'
} > "${BINARIES_DIR}/pxeboot/config.txt"

mkdir -p "${BINARIES_DIR}/pxeboot/pxelinux.cfg"

{
	echo 'default rpi'
	echo 'timeout 0'
	echo ''
	echo 'label rpi'
	echo '  kernel kernel.img'
	echo '  append console=ttyAMA0,115200 earlyprintk=ttyAMA0,115200 coherent_pool=4M quiet splash'
	echo '  initrd initrd.img'
} > "${BINARIES_DIR}/pxeboot/pxelinux.cfg/default"

cp "${BINARIES_DIR}/rpi-firmware/start.elf" "${BINARIES_DIR}/pxeboot/start.elf"
cp "${BINARIES_DIR}/rpi-firmware/fixup.dat" "${BINARIES_DIR}/pxeboot/fixup.dat"

mkdir -p "${BINARIES_DIR}/pxeboot/overlays"
for dtb in "${BINARIES_DIR}"/rpi-firmware/overlays/*.dtb*; do
	cp "${dtb}" "${BINARIES_DIR}/pxeboot/overlays/${dtb##*/}"
done

cp "${BINARIES_DIR}/u-boot.bin" "${BINARIES_DIR}/pxeboot/u-boot.bin"
cp "${BINARIES_DIR}/Image" "${BINARIES_DIR}/pxeboot/kernel.img"
cp "${BINARIES_DIR}/rootfs.cpio.zst" "${BINARIES_DIR}/pxeboot/initrd.img"
cp "${BINARIES_DIR}/bcm2711-rpi-4-b.dtb" "${BINARIES_DIR}/pxeboot/bcm2711-rpi-4-b.dtb"
