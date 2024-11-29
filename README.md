| master | styhead | scarthgap | kirkstone |
| ------ | ------- | --------- | --------- |
| [![build (master)][gh_badge_master]][gh_action_master] | [![build (styhead)][gh_badge_styhead]][gh_action_styhead] | [![build (scarthgap)][gh_badge_scarthgap]][gh_action_scarthgap] | [![build (kirkstone)][gh_badge_kirkstone]][gh_action_kirkstone] |

The meta-ptx layer provides support for classes and recipes that are meant to
be public but did not make it into any other common layer, yet.
Currently, it provides:

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

[gh_action_master]: https://github.com/pengutronix/meta-ptx/actions?query=event%3Aworkflow_dispatch+branch%3Amaster++
[gh_action_styhead]: https://github.com/pengutronix/meta-ptx/actions?query=event%3Aworkflow_dispatch+branch%3Astyhead++
[gh_action_scarthgap]: https://github.com/pengutronix/meta-ptx/actions?query=event%3Aworkflow_dispatch+branch%3Ascarthgap++
[gh_action_kirkstone]: https://github.com/pengutronix/meta-ptx/actions?query=event%3Aworkflow_dispatch+branch%3Akirkstone++

[gh_badge_master]: https://github.com/pengutronix/meta-ptx/actions/workflows/build.yml/badge.svg?branch=master&event=workflow_dispatch
[gh_badge_styhead]: https://github.com/pengutronix/meta-ptx/actions/workflows/build.yml/badge.svg?branch=styhead&event=workflow_dispatch
[gh_badge_scarthgap]: https://github.com/pengutronix/meta-ptx/actions/workflows/build.yml/badge.svg?branch=scarthgap&event=workflow_dispatch
[gh_badge_kirkstone]: https://github.com/pengutronix/meta-ptx/actions/workflows/build.yml/badge.svg?branch=kirkstone&event=workflow_dispatch
