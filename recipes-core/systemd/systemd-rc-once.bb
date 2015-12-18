SUMMARY = "Execute initial services once with rw mount"
SECTION = "examples"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
  file://rc-once.service \
  file://rc-once.sh \
  file://systemd-rc-once \
  "

S = "${WORKDIR}"

inherit allarch systemd

do_install() {
	install -d ${D}${base_libdir}/init
	install -m 0755 ${WORKDIR}/rc-once.sh ${D}${base_libdir}/init/
	install -d ${D}${systemd_unitdir}/system
	install -m 0755 ${WORKDIR}/systemd-rc-once ${D}${systemd_unitdir}/
	install -m 0644 ${WORKDIR}/rc-once.service ${D}${systemd_unitdir}/system/
	install -d ${D}${systemd_unitdir}/system/system-update.target.wants
	ln -sf ../rc-once.service ${D}${systemd_unitdir}/system/system-update.target.wants/rc-once.service
	install -d ${D}${sysconfdir}/rc.once.d
}

FILES_${PN} += "\
  /lib/init/rc-once.sh \
  /lib/systemd/systemd-rc-once \
  /lib/systemd/system/system-update.target.wants/rc-once.service \
"

SYSTEMD_SERVICE_${PN} = "rc-once.service"

pkg_postinst_${PN}() {
	ln -sf etc/rc.once.d $D/system-update
}
