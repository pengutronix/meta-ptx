# genimage.bbclas
#
# Class to generate disk images using the `genimage` tool.
#
# In order to build an image, your recipe must inherit the genimage class and
# have a valid genimage configuration file in SRC_URI, named `genimage.config`.
#
#   inherit genimage
#
#   SRC_URI += "file://genimage.config"
#
# You also need to depend on all recipes creating artifacts used by
# genimage to build the final (disk) image, e.g.:
#
#   do_genimage[depends] += "virtual/bootloader core-image-minimal:do_image_complete"
#
# The main purpose of genimage is to create an entire SD, eMMC, NAND, or UBI
# image with multiple partitions based on different images (kernel,
# bootloader, rootfs, ...)
#
# The name of the resulting image is named the same way normal images are
# named. You can customize output with the variables `GENIMAGE_IMAGE_NAME` and
# `GENIMAGE_IMAGE_SUFFIX`.
#
# Note that you should also make your genimage image recipe depend on the set
# of host tools required for building, e.g.
#
#   DEPENDS += "e2fsprogs-native genext2fs-native"
#
# You can also use genimage to split up a created rootfs into different
# partition images. Consider a yocto-created rootfs, for example.
# You can put all content of the /home directory in a 'data' partition while
# putting all content of /etc in a config partition and the rest ('/') in the
# final rootfs partition, then pack all them together to an SD image.
#
# In order to do this, you have to provide the name of the image recipe you
# intend to split up the data for:
#
#   GENIMAGE_ROOTFS_IMAGE = "my-production-image"
#
# The image recipe must build an archive, either `tar.bz2` (default) or the
# type matching the extension you set with `GENIMAGE_ROOTFS_IMAGE_FSTYPE`:
#
#   GENIMAGE_ROOTFS_IMAGE_FSTYPE = "tar.xz"
#
# The split-up is controlled by your genimage config file, using the
# 'mountpoint' options:
#
#   datafs {
#     [...]
#     mountpoint = "/home"
#   }
#
#   rootfs {
#     [...]
#     mountpoint = "/"
#   }
#
# Most common variables for customization from image recipe:
#
# GENIMAGE_IMAGE_SUFFIX	- file extension suffix for created image (default: 'img')
# GENIMAGE_ROOTFS_IMAGE - input rootfs image to generate file system images from
# GENIMAGE_ROOTFS_IMAGE_FSTYPE	- input roofs FSTYPE to use (default: 'tar.bz2')

inherit image-artifact-names deploy

LICENSE = "MIT"
PACKAGES = ""

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}"

B = "${WORKDIR}/genimage-${PN}"

INHIBIT_DEFAULT_DEPS = "1"

DEPENDS += "genimage-native"

GENIMAGE_IMAGE_SUFFIX ?= "img"

GENIMAGE_IMAGE_NAME = "${IMAGE_BASENAME}-${MACHINE}-${DATETIME}"
# Don't include the DATETIME variable in the sstate package signature
GENIMAGE_IMAGE_NAME[vardepsexclude] = "DATETIME"
GENIMAGE_IMAGE_LINK_NAME = "${IMAGE_BASENAME}-${MACHINE}"

GENIMAGE_ROOTFS_IMAGE ?= ""
GENIMAGE_ROOTFS_IMAGE_FSTYPE ?= "tar.bz2"

do_genimage[depends] += "${@'${GENIMAGE_ROOTFS_IMAGE}:do_image_complete' if '${GENIMAGE_ROOTFS_IMAGE}' else ''}"

GENIMAGE_TMPDIR  = "${WORKDIR}/genimage-tmp"
GENIMAGE_ROOTDIR  = "${WORKDIR}/root"

do_genimage[cleandirs] = "${GENIMAGE_TMPDIR} ${GENIMAGE_ROOTDIR}"

do_configure () {
    if grep -vq "@IMAGE@" ${WORKDIR}/genimage.config; then
        bbnote "genimage.config does not contain @IMAGE@ marker"
    fi

    cp ${WORKDIR}/genimage.config ${B}/.config
}

do_genimage[dirs] = "${B}"

fakeroot do_genimage () {

    # unpack input rootfs image if given
    if [ "x${GENIMAGE_ROOTFS_IMAGE}" != "x" ]; then
        bbnote "Unpacking ${DEPLOY_DIR_IMAGE}/${GENIMAGE_ROOTFS_IMAGE}-${MACHINE}.${GENIMAGE_ROOTFS_IMAGE_FSTYPE} to ${GENIMAGE_ROOTDIR}"
        tar -xf ${DEPLOY_DIR_IMAGE}/${GENIMAGE_ROOTFS_IMAGE}-${MACHINE}.${GENIMAGE_ROOTFS_IMAGE_FSTYPE} -C ${GENIMAGE_ROOTDIR}
    fi

    sed s:@IMAGE@:${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}:g ${B}/.config > ${B}/.config.tmp

    genimage \
        --loglevel 2 \
        --config ${B}/.config.tmp \
        --tmppath ${GENIMAGE_TMPDIR} \
        --inputpath ${DEPLOY_DIR_IMAGE} \
        --outputpath ${B} \
        --rootpath ${GENIMAGE_ROOTDIR}

    rm ${B}/.config.tmp
}
do_genimage[depends] += "virtual/fakeroot-native:do_populate_sysroot"

addtask genimage after do_configure before do_build

do_deploy () {
    install ${B}/* ${DEPLOYDIR}/

    if [ -e ${DEPLOYDIR}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX} ]; then
        ln -sf ${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX} ${DEPLOYDIR}/${GENIMAGE_IMAGE_LINK_NAME}.${GENIMAGE_IMAGE_SUFFIX}
    fi
}

addtask deploy after do_genimage before do_build

do_patch[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot
do_package[noexec] = "1"
deltask do_package_qa
do_packagedata[noexec] = "1"
deltask do_package_write_ipk
deltask do_package_write_deb
deltask do_package_write_rpm

