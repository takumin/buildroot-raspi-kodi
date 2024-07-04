#!/bin/bash
# vim: set noet :

set -eu

# Root SSH Public Keys
mkdir -p "${TARGET_DIR}/root/.ssh"
chmod 0700 "${TARGET_DIR}/root/.ssh"
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB/qb8XxUTnQQgEYF3W2ZaVu8VWqzoYNxpKA/FOFDhoG root' > "${TARGET_DIR}/root/.ssh/authorized_keys"

# Xorg Workaround
if [ -d "${TARGET_DIR}/etc/X11" ]; then
	cat > "${TARGET_DIR}/etc/X11/xorg.conf" <<- '__EOF__'
	Section "Module"
		Load "shadow"
		Load "fbdevhw"
	EndSection
	__EOF__
fi

# NoDM Configure
# if [ -e "${TARGET_DIR}/lib/systemd/system/nodm.service" ]; then
# 	cat > "${TARGET_DIR}/lib/systemd/system/nodm.service" <<- '__EOF__'
# 	[Unit]
# 	Description=Automatic display manager
# 	Documentation=https://github.com/spanezz/nodm
# 	After=systemd-user-sessions.service
# 
# 	[Service]
# 	Environment=NODM_USER="kodi"
# 	Environment=NODM_X_OPTIONS="vt7 -nolisten tcp"
# 	Environment=NODM_XSESSION="/etc/X11/Xsession"
# 	Environment=NODM_MIN_SESSION_TIME="60"
# 	Environment=NODM_X_TIMEOUT="30"
# 	ExecStart=/usr/sbin/nodm
# 	Restart=always
# 	__EOF__
# 
# 	mkdir -p "${TARGET_DIR}/etc/X11"
# 	chmod 0755 "${TARGET_DIR}/etc/X11"
# 	cat > "${TARGET_DIR}/etc/X11/Xsession" <<- '__EOF__'
# 	#!/bin/sh
# 
# 	/usr/bin/xterm &
# 
# 	exec /usr/bin/matchbox-window-manager -use_titlebar no $@
# 	__EOF__
# 	chmod 0755 "${TARGET_DIR}/etc/X11/Xsession"
# fi

# Kodi Configure
# mkdir -p "${TARGET_DIR}/home/kodi/.kodi/userdata"
# cat > "${TARGET_DIR}/home/kodi/.kodi/userdata/advancedsettings.xml" << '__EOF__'
# <advancedsettings version="1.0">
# 	<cputempcommand>sed -e 's/\([0-9]*\)[0-9]\{3\}.*/\1 C/' /sys/class/thermal/thermal_zone0/temp</cputempcommand>
# 	<gputempcommand>vcgencmd measure_temp | sed -e "s/temp=//" -e "s/\..*'/ /"</gputempcommand>
# </advancedsettings>
# __EOF__
# chown -R 500:500 "${TARGET_DIR}/home/kodi"

# Kodi Service
# cat > "${TARGET_DIR}/usr/lib/systemd/system/kodi.service" << __EOF__
# [Unit]
# Description=Kodi Entertainment Center
# After=local-fs.target
# 
# [Service]
# User=kodi
# Group=kodi
# PAMName=login
# TTYPath=/dev/tty1
# StandardInput=tty
# StandardOutput=journal
# Type=simple
# ExecStart=/usr/lib/kodi/kodi.bin -fs --standalone
# Restart=always
# 
# [Install]
# Alias=display-manager.service
# __EOF__

# ISDB-T Workaround
# if [ ! -e "${TARGET_DIR}/usr/lib/firmware/isdbt_rio.inp" ]; then
# 	wget --ca-certificate=/etc/ssl/certs/ca-certificates.crt \
# 		-O "${TARGET_DIR}/usr/lib/firmware/isdbt_rio.inp" \
# 		"https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/isdbt_rio.inp"
# fi
