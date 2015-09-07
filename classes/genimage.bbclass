LICENSE = "MIT"
PACKAGES = ""

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}"

INHIBIT_DEFAULT_DEPS = "1"

do_unpack[nostamp] = "1"
do_genimage[nostamp] = "1"
do_genimage[depends] += "genimage-native:do_populate_sysroot mtd-utils-native:do_populate_sysroot"

do_build[nostamp] = "1"

do_genimage () {
    cd ${WORKDIR}

    rm -rf ${WORKDIR}/genimage-tmp
    mkdir -p ${WORKDIR}/genimage-tmp

    sed -i s:@IMAGE@:${IMAGE_BASENAME}.img:g ${WORKDIR}/genimage.config

    mkdir -p ${WORKDIR}/root

    genimage \
        --config ${WORKDIR}/genimage.config \
        --tmppath ${WORKDIR}/genimage-tmp \
        --inputpath ${DEPLOY_DIR_IMAGE} \
        --outputpath ${DEPLOY_DIR_IMAGE} \
        --rootpath ${WORKDIR}/root
}

do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
do_populate_sysroot[noexec] = "1"
do_package[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"

addtask genimage after do_unpack before do_build
