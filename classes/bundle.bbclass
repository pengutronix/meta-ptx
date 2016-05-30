# Class for creating rauc bundles
#
# Description:
# 
# You have to set the slot images in your recipe file following this example:
#
#   RAUC_BUNDLE_COMPATIBLE ?= "My Super Product"
#   RAUC_BUNDLE_VERSION ?= "v2015-06-07-1"
#   
#   RAUC_BUNDLE_SLOTS ?= "rootfs kernel bootloader"
#   
#   RAUC_SLOT_rootfs ?= "core-image-minimal"
#   
#   RAUC_SLOT_kernel ?= "linux-yocto"
#   RAUC_SLOT_kernel[type] ?= "kernel"
#   
#   RAUC_SLOT_bootloader ?= "barebox"
#   RAUC_SLOT_bootloader[type] ?= "boot"
#
#
# Additionally you need to provide a certificate and a key file
#
#   RAUC_KEY_FILE ?= "development-1.key.pem"
#   RAUC_CERT_FILE ?= "development-1.cert.pem"

LICENSE = "MIT"

PACKAGE_ARCH = "${MACHINE_ARCH}"

RAUC_IMAGE_FSTYPE ?= "ext4"

do_fetch[cleandirs] = "${S}"
do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
do_populate_sysroot[noexec] = "1"
do_package[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"


# Create dependency list from images
do_fetch[depends] = "${@' '.join([d.getVar(image, True) + ":do_build" for image in \
    ['RAUC_SLOT_' + slot for slot in d.getVar('RAUC_BUNDLE_SLOTS', True).split()]])}"

S = "${WORKDIR}"

RAUC_KEY_FILE ?= "development-1.key.pem"
RAUC_CERT_FILE ?= "development-1.cert.pem"

SRC_URI = "\
    file://${RAUC_KEY_FILE} \
    file://${RAUC_CERT_FILE} \
    "

DEPENDS = "rauc-native"

python do_fetch() {
    import shutil

    bb.utils.mkdirhier("${S}/bundle")
    try:
        manifest = open("${S}/bundle/manifest.raucm", 'w')
    except OSError:
        raise bb.build.FuncFailed('Unable to open manifest.raucm')

    manifest.write('[update]\n')
    manifest.write('compatible=${RAUC_BUNDLE_COMPATIBLE}\n')
    manifest.write('version=${RAUC_BUNDLE_VERSION}\n')
    manifest.write('\n')

    for slot in d.getVar('RAUC_BUNDLE_SLOTS', True).split():
        manifest.write('[image.%s]\n' % slot)
        slotflags = d.getVarFlags('RAUC_SLOT_%s' % slot)
        if slotflags and 'type' in slotflags:
            imgtype = slotflags.get('type')
        else:
            imgtype = 'image'

        if imgtype == 'image':
            imgname = "%s-%s.%s" % (d.getVar('RAUC_SLOT_%s' % slot, True), "${MACHINE}", "${RAUC_IMAGE_FSTYPE}")
        elif imgtype == 'kernel':
            # TODO: Add image type support
            imgname = "%s-%s.bin" % ("zImage", "${MACHINE}")
        elif imgtype == 'boot':
            # TODO: adapt if barebox produces determinable output images
            imgname = "%s" % ("barebox.img")
        else:
            raise bb.build.FuncFailed('Unknown image type: %s', imgtype)

        print imgname
        manifest.write("filename=%s\n" % imgname)
        manifest.write("\n")

        # Set or update symlinks to image files
        if os.path.lexists("${S}/bundle/%s" % imgname):
            bb.utils.remove("${S}/bundle/%s" % imgname)
        shutil.copy("${DEPLOY_DIR_IMAGE}/%s" % imgname, "${S}/bundle/%s" % imgname)
        if not os.path.exists("${S}/bundle/%s" % imgname):
            raise bb.build.FuncFailed('Failed creating symlink to %s' % imgname)

    manifest.close()
}

DEPLOY_DIR_BUNDLE ?= "${DEPLOY_DIR_IMAGE}/bundles"
DEPLOY_DIR_BUNDLE[doc] = "Points to where rauc bundles will be put in"

BUNDLE_BASENAME = "${PN}"
BUNDLE_NAME = "${BUNDLE_BASENAME}-${MACHINE}-${DATETIME}"
# Don't include the DATETIME variable in the sstate package sigantures
BUNDLE_NAME[vardepsexclude] = "DATETIME"
BUNDLE_LINK_NAME = "${BUNDLE_BASENAME}-${MACHINE}"

do_bundle() {
	if [ -e ${B}/bundle.raucb ]; then
		rm ${B}/bundle.raucb
	fi
	${STAGING_DIR_NATIVE}${bindir}/rauc bundle \
		--cert=${WORKDIR}/${RAUC_CERT_FILE} \
		--key=${WORKDIR}/${RAUC_KEY_FILE} \
		${S}/bundle \
		${B}/bundle.raucb
}

do_deploy() {
	install -d ${DEPLOY_DIR_BUNDLE}
	install ${B}/bundle.raucb ${DEPLOY_DIR_BUNDLE}/${BUNDLE_NAME}.raucb
	ln -sf ${BUNDLE_NAME}.raucb ${DEPLOY_DIR_BUNDLE}/${BUNDLE_LINK_NAME}.raucb
}

addtask bundle after do_configure before do_build
addtask deploy after do_bundle before do_build

