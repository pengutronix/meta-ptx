[![meta-ptx CI](https://github.com/pengutronix/meta-ptx/workflows/meta-ptx%20CI/badge.svg)](https://github.com/pengutronix/meta-ptx/actions?query=workflow%3A%22meta-ptx+CI%22)

The meta-ptx layer provides support for the `barebox` bootloader,
the `genimage` image generation mechanism, and some other useful tools and
patches

Dependencies
============

This layer depends on:

    URI: git://git.openembedded.org/bitbake
    branch: master

    URI: git://git.openembedded.org/openembedded-core
    layers: meta
    branch: master


Patches
=======

Please submit any patches against the ptx layer as Pull Request to GitHub
repository https://github.com/pengutronix/meta-ptx

Maintainer: Enrico Jörns <yocto@pengutronix.de>


Adding the ptx layer to your build
==================================

In order to use this layer, you need to make the build system aware of
it.

Assuming the ptx layer exists at the top-level of your
yocto build tree, you can add it to the build system by adding the
location of the ptx layer to bblayers.conf, along with any
other layers needed. e.g.:

    BBLAYERS ?= " \
      /path/to/yocto/meta \
      /path/to/yocto/meta-yocto \
      /path/to/yocto/meta-yocto-bsp \
      /path/to/yocto/meta-ptx \
      "

