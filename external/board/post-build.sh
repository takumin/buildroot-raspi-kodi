#!/bin/sh
# vim: set noet :

set -eu

################################################################################
#
# Workaround: Install Raspberry Pi Kernel DTB Files
#
################################################################################

LINUX_BUILD_DIR="${BUILD_DIR}/linux-custom"
LINUX_ARCH_BUILD_DIR="${LINUX_BUILD_DIR}/arch/arm64"

# Device Tree Blobs
for dtb in "${LINUX_ARCH_BUILD_DIR}"/boot/dts/broadcom/bcm271*.dtb; do
	cp "${dtb}" "${BINARIES_DIR}"/
done

# Device Tree Blob Overlays
mkdir -p "${BINARIES_DIR}"/overlays
cp "${LINUX_ARCH_BUILD_DIR}"/boot/dts/overlays/README "${BINARIES_DIR}"/overlays/README
for dtb in "${LINUX_ARCH_BUILD_DIR}"/boot/dts/overlays/*.dtb; do
	cp "${dtb}" "${BINARIES_DIR}"/overlays/
done
for dtbo in "${LINUX_ARCH_BUILD_DIR}"/boot/dts/overlays/*.dtbo; do
	cp "${dtbo}" "${BINARIES_DIR}"/overlays/
done

# Fix Permission
for dtb in "${BINARIES_DIR}"/*.dtb; do
	chmod 0644 "${dtb}"
done
for dtbo in "${BINARIES_DIR}"/overlays/*; do
	chmod 0644 "${dtbo}"
done
