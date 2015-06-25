SUMMARY = "Image generation tool"

SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://genimage.c;beginline=1;endline=16;md5=89d7f9ff68e4a08b3e2ec01729a3949f"

DEPENDS = "confuse dosfstools"

SRC_URI = "http://www.pengutronix.de/software/genimage/download/genimage-${PV}.tar.xz"

EXTRA_OECONF = "--enable-largefile"

inherit autotools gettext

BBCLASSEXTEND = "native"
