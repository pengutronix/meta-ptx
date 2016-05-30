# Adds boot spec entry for first FSTYPE found

BOOTSPEC_TITLE ?= "${SUMMARY} - boot spec entry"
BOOTSPEC_TITLE[doc] = "Content of the boot spec entry 'title' line"

BOOTSPEC_OPTIONS_ext4 = "rootfstype=ext4 rootwait"
BOOTSPEC_OPTIONS_ubi = "rootfstype=ubifs"

BOOTSPEC_VERSION ?= "1.0"
BOOTSPEC_VERSION[doc] ?= "Content of the bootspec version entry"

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

BOOTSPEC_EXTRALINE ?= ""
BOOTSPEC_OPTIONS[doc] = "Allows to add extra content to bootspec entries, lines must be terminated with a newline"

python create_bootspec() {
    dtb = d.getVar('KERNEL_DEVICETREE', '').replace('.dtb', '').split()
    bb.utils.mkdirhier("${IMAGE_ROOTFS}/loader/entries/")

    for x in dtb:
        bb.note("Creating boot spec entry /loader/entries/" + x + ".conf ...")

        try:
            bootspecfile = open("${IMAGE_ROOTFS}/loader/entries/" + x + ".conf", 'w')
        except OSError:
            raise bb.build.FuncFailed('Unable to open boot spec file for writing')

        bootspecfile.write('title      ${BOOTSPEC_TITLE}\n')
        bootspecfile.write('version    ${BOOTSPEC_VERSION}\n')
        bootspecfile.write('options    ${BOOTSPEC_OPTIONS}\n')
        bootspecfile.write('${BOOTSPEC_EXTRALINE}')
        bootspecfile.write('linux      /boot/${KERNEL_IMAGETYPE}\n')
        bootspecfile.write('devicetree /boot/devicetree-${KERNEL_IMAGETYPE}-' + x + '.dtb\n')

        bootspecfile.close()
}

ROOTFS_POSTPROCESS_COMMAND += " create_bootspec; "
