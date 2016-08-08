DESCRIPTION = "rauc update controller for host and target"
HOMEPAGE = "https://github.com/jluebbe/rauc"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c"


SRC_URI = "file://rauc.service file://rauc-mark-good.service "

DEPENDS = "curl openssl glib-2.0"
RDEPENDS_${PN}_class-target = "barebox-state"
RRECOMMENDS_${PN} = "squashfs-tools"
RRECOMMENDS_${PN}_append_class-target = " mtd-utils ${PN}-mark-good"

PACKAGES =+ "${PN}-service ${PN}-mark-good"

FILES_${PN}_append = " /mnt/rauc"
FILES_${PN}-service = "${sysconfdir}/dbus-1/system.d/de.pengutronix.rauc.conf"
FILES_${PN}-service += "${systemd_unitdir}/system/rauc.service"
FILES_${PN}-mark-good = "${systemd_unitdir}/system/rauc-mark-good.service"

PACKAGECONFIG ??= "service"
PACKAGECONFIG_class-native = ""
PACKAGECONFIG_class-nativesdk = ""
PACKAGECONFIG[service] = "--enable-service,--enable-service=no,,${PN}-service"

inherit autotools pkgconfig gettext systemd

RAUC_KEYRING_FILE ??= "openssl-ca/dev-ca.pem"
RAUC_KEYRING_FILE[doc] = "Path to keyring file to be placed in rauc images"

SRC_URI += "file://${RAUC_KEYRING_FILE}"

do_install_append_class-target () {

	# Create rauc config dir
	install -d ${D}${sysconfdir}/rauc

	# Create rauc default mountpoint
	install -d ${D}/mnt/rauc

	# If a system.conf is provided in files, install it, otherwise warn
	if [ -f ${WORKDIR}/system.conf ]; then
		install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/rauc/system.conf
	else
		bbwarn "No system.conf provided"
	fi

	# CA file
	if [ -f ${WORKDIR}/${RAUC_KEYRING_FILE} ]; then
		install -d ${D}${sysconfdir}/rauc/openssl-ca
		install -m 0644 ${WORKDIR}/${RAUC_KEYRING_FILE} ${D}${sysconfdir}/rauc/openssl-ca/; \
	else
		bbwarn "No keyring file provided"
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

inherit deploy
do_deploy[sstate-outputdirs] = "${DEPLOY_DIR_TOOLS}"

do_deploy() {
}

do_deploy_append_class-native() {
    install -d ${DEPLOY_DIR_TOOLS}
    install -m 0755 ${B}/rauc ${DEPLOY_DIR_TOOLS}/rauc-${PV}
    rm -f ${DEPLOY_DIR_TOOLS}/rauc
    ln -sf ./rauc-${PV} ${DEPLOY_DIR_TOOLS}/rauc
}

addtask deploy before do_package after do_install

SYSTEMD_PACKAGES = "${PN}-service ${PN}-mark-good"
SYSTEMD_SERVICE_${PN}-service = "rauc.service"
SYSTEMD_SERVICE_${PN}-mark-good = "rauc-mark-good.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

BBCLASSEXTEND = "native nativesdk"
