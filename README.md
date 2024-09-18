[![meta-ptx CI](https://github.com/pengutronix/meta-ptx/workflows/meta-ptx%20CI/badge.svg)](https://github.com/pengutronix/meta-ptx/actions?query=workflow%3A%22meta-ptx+CI%22)

The meta-ptx layer provides support for classes and recipes that are meant to
be public but did not make it into any other common layer, yet.
Currently, it provides:

* a recipe for the `barebox` bootloader
* the [genimage.bbclass](https://github.com/pengutronix/meta-ptx/blob/master/classes-recipe/genimage.bbclass)
  for creating images using genimage
* a recipe for [platsch](https://github.com/pengutronix/platsch), an early splash screen application
* the [platsch.bbclass](https://github.com/pengutronix/meta-ptx/blob/master/classes-recipe/platsch.bbclass)
  for creating splash image recipes
* a recipe for the [memtool](https://github.com/pengutronix/memtool) utility
* the [bootspec.bbclass](https://github.com/pengutronix/meta-ptx/blob/master/classes-recipe/bootspec.bbclass)
  for adding [bootloader specification](https://uapi-group.org/specifications/specs/boot_loader_specification/) files to the rootfs

Dependencies
============

This layer depends on:

    URI: git://git.openembedded.org/bitbake
    branch: master

    URI: git://git.openembedded.org/openembedded-core
    layers: meta
    branch: master

    URI: https://github.com/openembedded/meta-openembedded.git
    layers: meta-oe
    branch: master


Patches
=======

Please submit any patches against the ptx layer as Pull Request to GitHub
repository https://github.com/pengutronix/meta-ptx

Maintainer: Enrico Jörns <yocto@pengutronix.de>


Adding the ptx layer to your build
==================================

Run ``bitbake-layers add-layer meta-ptx``.
