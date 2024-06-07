SUMMARY = "The image creation tool"
HOMEPAGE = "https://github.com/pengutronix/genimage"

SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS = "confuse dosfstools"

SRC_URI = "http://www.pengutronix.de/software/genimage/download/genimage-${PV}.tar.xz"

EXTRA_OECONF = "--enable-largefile"

inherit pkgconfig autotools gettext

BBCLASSEXTEND = "native nativesdk"
