DESCRIPTION = "Simple splash screen application"
HOMEPAGE = "https://github.com/pengutronix/platsch"
LICENSE = "0BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1a4c8b8d288b4fc32c3c4830d7a5e169"

SRC_URI = "git://github.com/pengutronix/platsch.git;protocol=https;branch=main"
SRCREV = "157afbc883c6a56d89e78032f230feb8f46ab779"
S = "${WORKDIR}/git"

DEPENDS = "libdrm"

inherit pkgconfig meson

PACKAGES =+ "lib${BPN}"

FILES:lib${BPN} = "${libdir}/libplatsch.so.*"
