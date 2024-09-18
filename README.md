[![meta-ptx CI](https://github.com/pengutronix/meta-ptx/workflows/meta-ptx%20CI/badge.svg)](https://github.com/pengutronix/meta-ptx/actions?query=workflow%3A%22meta-ptx+CI%22)

The meta-ptx layer provides support for the `barebox` bootloader,
the `genimage` image generation mechanism, and some other useful tools and
patches

It provides it own sample distro `ptx` which is based on systemd.

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

Run ``bitbake-layers add-layer meta-ptx``.
