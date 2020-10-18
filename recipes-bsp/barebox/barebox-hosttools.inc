# Copyright (C) 2020 Roland Hieber, Pengutronix <rhi@pengutronix.de>
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "barebox host tools - imx-usb-loader, kwboot, omap-usb-loader"
HOMEPAGE = "https://www.barebox.org/"
SECTION = "bootloaders"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=f5125d13e000b9ca1f0d3364286c4192"

SRC_URI = "http://barebox.org/download/barebox-${PV}.tar.bz2"
S = "${WORKDIR}/barebox-${PV}"

BBCLASSEXTEND = "native nativesdk"

inherit pkgconfig
DEPENDS = "flex-native bison-native libusb1"

export ARCH = "sandbox"

do_configure() {
	oe_runmake hosttools_defconfig
}

do_compile() {
	oe_runmake scripts/
}

do_install() {
	install -d -m 0755 ${D}${bindir}/

	for tool in \
		imx/imx-usb-loader \
		kwboot \
		omap3-usb-loader \
		omap4_usbboot \
	; do
		install -m 0755 ${B}/scripts/${tool} ${D}${bindir}/
	done
}

PACKAGES = "\
    barebox-imx-usb-loader barebox-imx-usb-loader-dbg \
    barebox-kwboot barebox-kwboot-dbg \
    barebox-omap-usb-tools barebox-omap-usb-tools-dbg \
"

NOAUTOPACKAGEDEBUG = "1"
FILES_barebox-imx-usb-loader = "${bindir}/imx-usb-loader"
FILES_barebox-imx-usb-loader-dbg = "${bindir}/.debug/imx-usb-loader"
FILES_barebox-kwboot = "${bindir}/kwboot"
FILES_barebox-kwboot-dbg = "${bindir}/.debug/kwboot"
FILES_barebox-omap-usb-tools = "${bindir}/omap3-usb-loader ${bindir}/omap4_usbboot"
FILES_barebox-omap-usb-tools-dbg = "${bindir}/.debug/omap3-usb-loader ${bindir}/.debug/omap4_usbboot"
