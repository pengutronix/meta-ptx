DESCRIPTION = "device-tree and barebox-related tools"
HOMEPAGE = "http://git.pengutronix.de/?p=tools/dt-utils.git"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88"
DEPENDS = "udev"
SRCREV = "b1a52928e7bf4126bbe014ee434bd91c4f804bba"
PR = "r0"

SRC_URI = "git://git.pengutronix.de/git/tools/dt-utils.git \
        file://0001-remove-init-option-use-default-if-load-failed.patch "

S = "${WORKDIR}/git"

inherit autotools pkgconfig gettext

PACKAGES =+ "${PN}-barebox-state ${PN}-fdtdump ${PN}-dtblint"

FILES_${PN}-barebox-state = "${bindir}/barebox-state"
FILES_${PN}-fdtdump = "${bindir}/fdtdump"
FILES_${PN}-dtblint = "${bindir}/dtblint"
