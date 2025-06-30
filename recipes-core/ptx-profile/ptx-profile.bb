DESCRIPTION = "PTX distro specific profile"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://00-ptx.sh"

S = "${UNPACKDIR}"

do_install () {
	install -d ${D}${sysconfdir}/profile.d/
	install -m 0755 ${S}/00-ptx.sh ${D}${sysconfdir}/profile.d/
}

FILES:${PN} = "${sysconfdir}/profile.d/00-ptx.sh"
