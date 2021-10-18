#!/bin/bash
# vim: set noet :

set -eu

# Init Workaround
if [ ! -e "${TARGET_DIR}/init" ]; then
	ln -sf "sbin/init" "${TARGET_DIR}/init"
fi

# Kodi Workaround
cat > "${TARGET_DIR}/usr/lib/systemd/system/kodi.service" <<- __EOF__
[Unit]
Description=Kodi Entertainment Center
After=network.target

[Service]
Type=simple
Environment=HOME=/var/kodi
ExecStart=/usr/lib/kodi/kodi.bin --standalone -fs -n
Restart=on-failure

[Install]
WantedBy=multi-user.target
__EOF__

# ISDB-T Workaround
if [ ! -e "${TARGET_DIR}/usr/lib/firmware/isdbt_rio.inp" ]; then
	wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt \
		-O "${TARGET_DIR}/usr/lib/firmware/isdbt_rio.inp" \
		"https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/isdbt_rio.inp"
fi
