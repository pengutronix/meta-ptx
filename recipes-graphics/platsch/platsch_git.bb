DESCRIPTION = "Simple splash screen application"
HOMEPAGE = "https://github.com/pengutronix/platsch"
LICENSE = "0BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1a4c8b8d288b4fc32c3c4830d7a5e169"

SRC_URI = "git://github.com/pengutronix/platsch.git;protocol=https;branch=main"
PV = "0.1+git${SRCPV}"
SRCREV = "9ba41fd75c7b0b5ba47549ed3fabe6d95c75987d"
S = "${WORKDIR}/git"

DEPENDS = "libdrm"

inherit pkgconfig autotools
