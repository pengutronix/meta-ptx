DESCRIPTION = "barebox state tool (dt-utils)"
SECTION = "examples"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88"
PR = "r0"

SRC_URI = "git://git.pengutronix.de/git/tools/dt-utils.git \
	file://0001-remove-init-option-use-default-if-load-failed.patch "

PACKAGES =+ "${PN}-barebox-state ${PN}-fdtdump ${PN}-dtblint"

FILES_${PN}-barebox-state = "${bindir}/barebox-state"
FILES_${PN}-fdtdump = "${bindir}/fdtdump"
FILES_${PN}-dtblint = "${bindir}/dtblint"

S = "${WORKDIR}/git"

SRCREV = "b1a52928e7bf4126bbe014ee434bd91c4f804bba"

DEPENDS = "udev"

inherit autotools pkgconfig gettext
