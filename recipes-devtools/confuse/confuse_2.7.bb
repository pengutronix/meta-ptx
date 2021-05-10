DESCRIPTION = "Library for parsing configuration files"
HOMEPAGE = "http://www.nongnu.org/confuse/"
LICENSE = "ISC"
SECTION = "libs"

LIC_FILES_CHKSUM = "file://src/confuse.c;beginline=1;endline=15;md5=90fe4e5c6740b817724d0da656d4155f"

SRC_URI = "http://download.savannah.gnu.org/releases/confuse/confuse-${PV}.tar.gz"

SRC_URI[md5sum] = "45932fdeeccbb9ef4228f1c1a25e9c8f"
SRC_URI[sha256sum] = "e32574fd837e950778dac7ade40787dd2259ef8e28acd6ede6847ca895c88778"

EXTRA_OECONF = "--enable-shared"

inherit autotools gettext binconfig pkgconfig lib_package

BBCLASSEXTEND = "native nativesdk"
