DESCRIPTION = "Library for parsing configuration files"
HOMEPAGE = "http://www.nongnu.org/confuse/"
LICENSE = "ISC"
SECTION = "libs"

LIC_FILES_CHKSUM = "file://LICENSE;md5=42fa47330d4051cd219f7d99d023de3a"

SRC_URI = "https://github.com/libconfuse/libconfuse/releases/download/v${PV}/confuse-${PV}.tar.gz"
SRC_URI[sha256sum] = "3a59ded20bc652eaa8e6261ab46f7e483bc13dad79263c15af42ecbb329707b8"

SRC_URI += "file://0001-only-apply-search-path-logic-to-relative-pathnames.patch"

EXTRA_OECONF = "--enable-shared"

inherit autotools gettext binconfig pkgconfig lib_package

BBCLASSEXTEND = "native nativesdk"
