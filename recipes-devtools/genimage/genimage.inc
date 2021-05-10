SUMMARY = "Image generation tool"

SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://genimage.c;beginline=1;endline=15;md5=bd66ae8b32d8a336e09c1d4a9924a49f"

DEPENDS = "confuse dosfstools"

SRC_URI = "http://www.pengutronix.de/software/genimage/download/genimage-${PV}.tar.xz"

EXTRA_OECONF = "--enable-largefile"

inherit pkgconfig autotools gettext

BBCLASSEXTEND = "native nativesdk"
