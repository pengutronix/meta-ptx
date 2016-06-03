SUMMARY = "Barebox - a bootloader that inherits the best of U-Boot and the Linux kernel"
HOMEPAGE = "http://www.barebox.org/"
SECTION = "bootloaders"
PROVIDES = "virtual/bootloader"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=057bf9e50e1ca857d0eb97bfe4ba8e5d"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit kernel-arch deploy
inherit cml1

DEPENDS = "libusb1-native lzop-native"

SRC_URI = "http://barebox.org/download/barebox-${PV}.tar.bz2"

S = "${WORKDIR}/barebox-${PV}"

COMPATIBLE_MACHINE = "none"

EXTRA_OEMAKE = "CROSS_COMPILE=${TARGET_PREFIX}"

do_configure_prepend() {
	if [ -e ${WORKDIR}/defconfig ]; then
		cp ${WORKDIR}/defconfig ${S}/.config
	else
		bbwarn "No defconfig given"
	fi

	# do not compile tools when using KERNEL_CC/KERNEL_LD
	echo CONFIG_BAREBOXENV_TARGET=n >> ${S}/.config
	echo CONFIG_BAREBOXCRC32_TARGET=n >> ${S}/.config
	echo CONFIG_KERNEL_INSTALL_TARGET=n >> ${S}/.config
	echo CONFIG_IMD_TARGET=n >> ${S}/.config
	oe_runmake oldconfig
}

do_compile () {
	# If there is an 'env' directory, append its content
	# to the compiled environment
	if [ -d ${WORKDIR}/env/ ]; then \
		mkdir -p ${S}/.yocto-defaultenv
		cp -r ${WORKDIR}/env/* ${S}/.yocto-defaultenv/; \
	        sed -i -e "s,^\(CONFIG_DEFAULT_ENVIRONMENT_PATH=.*\)\"$,\1 .yocto-defaultenv\"," \
		                ${B}/.config; \

	fi

	# Barebox uses pkg-config only for building native tools
	export PKG_CONFIG_LIBDIR="${STAGING_DIR_NATIVE}${libdir}/pkgconfig:${STAGING_DIR_NATIVE}/usr/share/pkgconfig"
	export PKG_CONFIG_SYSROOT_DIR=

	unset LDFLAGS
	unset CFLAGS
	unset CPPFLAGS
	unset CXXFLAGS
	unset MACHINE

	oe_runmake CC="${KERNEL_CC}" LD="${KERNEL_LD}"
}

# Suffix that allows to create different barebox images in one BSP
BAREBOX_IMAGE_SUFFIX = ""

do_deploy () {
	install -d ${DEPLOYDIR}
	if [ -e ${S}/barebox-flash-image ]; then
		install -m 644 -t ${DEPLOYDIR}/ ${S}/barebox-flash-image
	fi
	for IMAGE in ${S}/images/*.img; do
		if [ -e ${IMAGE} ]; then
			BAREBOX_IMG_BASENAME=$(basename ${IMAGE} .img)${BAREBOX_IMAGE_SUFFIX}
			install -m 644 -T ${IMAGE} ${DEPLOYDIR}/${BAREBOX_IMG_BASENAME}-${DATETIME}.img
			ln -sf ${BAREBOX_IMG_BASENAME}-${DATETIME}.img ${DEPLOYDIR}/${BAREBOX_IMG_BASENAME}.img
		fi
	done
}

addtask deploy before do_build after do_compile
