SUMMARY = "The image creation tool"
HOMEPAGE = "https://github.com/pengutronix/genimage"

SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS = "confuse"

SRC_URI = "${GITHUB_BASE_URI}/download/v${PV}/genimage-${PV}.tar.xz"

EXTRA_OECONF = "--enable-largefile"

inherit pkgconfig autotools gettext github-releases

GITHUB_BASE_URI = "https://github.com/pengutronix/genimage/releases"
UPSTREAM_CHECK_REGEX = "releases/tag/v?(?P<pver>\d+(\.\d+)*)"

BBCLASSEXTEND = "native nativesdk"
