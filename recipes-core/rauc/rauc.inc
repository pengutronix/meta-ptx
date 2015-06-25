DESCRIPTION = "rauc update controller for host and target"
HOMEPAGE = "https://github.com/jluebbe/rauc"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c"


SRC_URI = "file://rauc.service file://rauc-mark-good.service "

DEPENDS = "squashfs-tools-native curl openssl glib-2.0"
RDEPENDS_${PN} = "barebox-state"

FILES_${PN}_append = " /mnt/rauc"

inherit autotools pkgconfig gettext systemd

do_install_append () {
	# Create rauc config dir
	install -d ${D}${sysconfdir}/rauc

	# Create rauc default mountpoint
	install -d ${D}/mnt/rauc

	# If a system.conf is provided in files, install it
	if [ -f ${WORKDIR}/system.conf ]; then
		install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/rauc/system.conf
	fi

	if [ -f ${WORKDIR}/openssl-ca/dev-ca.pem ]; then
		install -d ${D}${sysconfdir}/rauc/openssl-ca
		install -m 0644 ${WORKDIR}/openssl-ca/dev-ca.pem ${D}${sysconfdir}/rauc/openssl-ca/dev-ca.pem
	fi

	# D-bus service
	install -d ${D}${sysconfdir}/dbus-1/system.d/
	install -m 0644 ${S}/data/de.pengutronix.rauc.conf ${D}${sysconfdir}/dbus-1/system.d/

	# Systemd service
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/rauc.service ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/rauc-mark-good.service ${D}${systemd_unitdir}/system/
	sed -i -e 's!@BINDIR@!${bindir}!g' ${D}${systemd_unitdir}/system/*.service

}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "rauc.service rauc-mark-good.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"


BBCLASSEXTEND = "native"
