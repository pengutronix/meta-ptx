# Adds boot spec entry for first FSTYPE found

BOOTSPEC_TITLE ?= "${SUMMARY}"
BOOTSPEC_TITLE[doc] = "Content of the boot spec entry 'title' line"

BOOTSPEC_FILENAME ?= "${MACHINE}.conf"
BOOTSPEC_FILENAME[doc] = "Name of the created boot spec entry file"

BOOTSPEC_OPTIONS_ext4 = "rootfstype=ext4 rootwait"
BOOTSPEC_OPTIONS_ubi = "rootfstype=ubifs"

BOOTSPEC_OPTIONS_DEFAULT = ""

python () {
    option = ""

    for type in (d.getVar('IMAGE_FSTYPES', True) or "").split():
        option = d.getVar('BOOTSPEC_OPTIONS_%s' % type, True)
	if option:
	    break;

    d.setVar('BOOTSPEC_OPTIONS_DEFAULT', option)
}

BOOTSPEC_OPTIONS ?= "${BOOTSPEC_OPTIONS_DEFAULT}"
BOOTSPEC_OPTIONS[doc] = "Content of the boot spec entry 'options' line"

python create_bootspec() {

    bb.note("Creating boot spec entry /loader/entries/${BOOTSPEC_FILENAME} ...")

    bb.utils.mkdirhier("${IMAGE_ROOTFS}/loader/entries/")

    try:
        bootspecfile = open("${IMAGE_ROOTFS}/loader/entries/${BOOTSPEC_FILENAME}", 'w')
    except OSError:
        raise bb.build.FuncFailed('Unable to open boot spec file for writing')

    bootspecfile.write('title      ${BOOTSPEC_TITLE} boot spec entry\n')
    bootspecfile.write('version    1.0\n')
    bootspecfile.write('options    ${BOOTSPEC_OPTIONS}\n')
    bootspecfile.write('linux      /boot/${KERNEL_IMAGETYPE}\n')
    bootspecfile.write('devicetree /boot/devicetree-${KERNEL_IMAGETYPE}-${KERNEL_DEVICETREE}\n')

    bootspecfile.close()
}

ROOTFS_POSTPROCESS_COMMAND += " create_bootspec; "
