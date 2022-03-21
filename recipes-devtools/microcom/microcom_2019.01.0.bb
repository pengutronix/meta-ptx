DESCRIPTION = "Minimalistic terminal program for communicating with devices over a serial connection"
HOMEPAGE = "https://github.com/pengutronix/microcom"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=c9f7c009791eaa4b9ca90dc4c9538d24"
DEPENDS = "readline"

SRC_URI = "https://github.com/pengutronix/microcom/releases/download/v${PV}/microcom-${PV}.tar.xz"
SRC_URI[sha256sum] = "87e6bacc545d110ae2bc4443e29d7ccac3c5737a40056d6eef1231e3d8667210"

EXTRA_OECONF = "--enable-largefile"

inherit autotools update-alternatives

PACKAGECONFIG ??= ""
PACKAGECONFIG[can] = "--enable-can,--disable-can"

# higher priority than busybox' microcom
ALTERNATIVE:${PN} = "microcom"
ALTERNATIVE_PRIORITY[microcom] = "100"
