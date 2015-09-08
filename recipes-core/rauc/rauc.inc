DESCRIPTION = "rauc update controller for host and target"
HOMEPAGE = "https://github.com/jluebbe/rauc"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c"


SRC_URI = "file://rauc.service file://rauc-mark-good.service "

DEPENDS = "squashfs-tools-native curl openssl glib-2.0"
RDEPENDS_${PN} = "barebox-state"
RDEPENDS_${PN}_class-native = ""

FILES_${PN}_append = " /mnt/rauc"

inherit autotools pkgconfig gettext systemd

RAUC_KEYRING_FILE ??= "openssl-ca/dev-ca.pem"
RAUC_KEYRING_FILE[doc] = "Path to keyring file to be placed in rauc images"

SRC_URI += "file://${RAUC_KEYRING_FILE}"

do_install_append () {
	# Create rauc config dir
	install -d ${D}${sysconfdir}/rauc

	# Create rauc default mountpoint
	install -d ${D}/mnt/rauc

	# If a system.conf is provided in files, install it
	if [ -f ${WORKDIR}/system.conf ]; then
		install -m 0644 ${WORKDIR}/system.conf ${D}${sysconfdir}/rauc/system.conf
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

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "rauc.service rauc-mark-good.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

BBCLASSEXTEND = "native"
