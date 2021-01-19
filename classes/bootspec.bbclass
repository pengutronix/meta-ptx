# Adds boot spec entry for first FSTYPE found

# require STAGING_KERNEL_BUILDDIR to be populated properly
do_rootfs[depends] += "virtual/kernel:do_shared_workdir"
inherit linux-kernel-base
KERNEL_VERSION = "${@get_kernelversion_file("${STAGING_KERNEL_BUILDDIR}")}"

BOOTSPEC_TITLE ?= "${SUMMARY}"
BOOTSPEC_TITLE[doc] = "Content of the boot spec entry 'title' line"

BOOTSPEC_OPTIONS_ext4 = "rootfstype=ext4 rootwait"
BOOTSPEC_OPTIONS_ubi = "rootfstype=ubifs"
BOOTSPEC_OPTIONS_squashfs = "rootfstype=squashfs"
BOOTSPEC_OPTIONS_squashfs-lzo = "rootfstype=squashfs"
BOOTSPEC_OPTIONS_squashfs-xz = "rootfstype=squashfs"

BOOTSPEC_VERSION ?= "${KERNEL_VERSION}"
BOOTSPEC_VERSION[doc] ?= "Content of the bootspec version entry"

BOOTSPEC_OPTIONS_DEFAULT = ""

python () {
    option = ""

    for type in (d.getVar('IMAGE_FSTYPES') or "").split():
        option = d.getVar('BOOTSPEC_OPTIONS_%s' % type)
        if option:
            d.setVar('BOOTSPEC_OPTIONS_DEFAULT', option)
            break;
}

BOOTSPEC_OPTIONS ?= "${BOOTSPEC_OPTIONS_DEFAULT}"
BOOTSPEC_OPTIONS[doc] = "Content of the boot spec entry 'options' line"

BOOTSPEC_EXTRALINE ?= ""
BOOTSPEC_EXTRALINE[doc] = "Allows to add extra content to bootspec entries, lines must be terminated with a newline"

python create_bootspec() {
    dtb = (d.getVar('KERNEL_DEVICETREE') or "default").replace('.dtb', '').split()
    bb.utils.mkdirhier(d.expand("${IMAGE_ROOTFS}/loader/entries/"))

    for x in dtb:
        x = os.path.basename(x)
        bb.note("Creating boot spec entry /loader/entries/" + x + ".conf ...")

        try:
            bootspecfile = open(d.expand("${IMAGE_ROOTFS}/loader/entries/" + x + ".conf"), 'w')
        except OSError:
            raise bb.build.FuncFailed('Unable to open boot spec file for writing')

        bootspecfile.write('title      %s\n' % d.getVar('BOOTSPEC_TITLE'))
        bootspecfile.write('version    %s\n' % d.getVar('BOOTSPEC_VERSION'))
        bootspecfile.write('options    %s\n' % d.expand('${BOOTSPEC_OPTIONS}'))
        bootspecfile.write(d.getVar('BOOTSPEC_EXTRALINE').replace(r'\n', '\n'))
        bootspecfile.write('linux      %s\n' % d.expand('/boot/${KERNEL_IMAGETYPE}-${KERNEL_VERSION}'))
        if x != "default":
            bootspecfile.write('devicetree %s\n' % d.expand('/boot/' + x + '.dtb\n'))

        bootspecfile.close()
}

ROOTFS_POSTPROCESS_COMMAND += " create_bootspec; "

IMAGE_INSTALL_append = " kernel-image"
IMAGE_INSTALL_append = '${@ " kernel-devicetree" if d.getVar('KERNEL_DEVICETREE') else ""}'
