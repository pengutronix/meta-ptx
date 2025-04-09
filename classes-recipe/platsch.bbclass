# Class to simplify the conversion of images to be displayed by "platsch" as splash images
#
# Description:
#
# "platsch" expects raw bitmaps in a format that the target's graphics
# hardware's display controller is able to scan out without further pre-
# processing. This class helps creating them starting from conventionally
# formatted images whose filenames have to satisfy the following scheme:
#
#   <base>-<width>x<height>.<extension>
#
# In the recipe the conventional images to be converted are listed and the raw
# format that they shall be converted to is specified:
#
#   SPLASH_IMAGES = "splash-1280x800.png splash-800x480.png"
#   SPLASH_FORMAT = "RGB565"
#
# Of course, those source images have to be listed in SRC_URI beforehand.
#
# If the raw format that you need for your hardware is not supported by this
# class up to now, you are invited to create a corresponding pull request.
#
# ImageMagick's BMP encoder always creates "bottom-up" bitmap data whereas the
# i.MX6/i.MX8 expect the pixel array to be stored "top-down" so that one needs
# to compensate for it by flipping the image during the conversion (see [1] and
# [2] further down). To make things like that possible there is the bitbake
# parameter SPLASH_MGK_CUSTOM_OPTION which is weakly predefined to flip the
# image and which can be overwritten in any recipe utilizing this class if
# required.
#
# If the resulting images shall not be installed to the default location (which
# is /usr/share/platsch) choose another directory via
#
#   SPLASH_DATADIR = "/some/different/directory"
#
# Finally the class automatically appends the converted images to the
# FILES:${PN} parameter.
#

SPLASH_IMAGES ??= ""
SPLASH_IMAGES[doc] = "Space-separated list of conventionally formatted images (*.png, *.jpg etc.) to be converted by this class."

SPLASH_FORMAT ??= "undefined"
SPLASH_FORMAT[doc] = "Target format that the graphics hardware's display controller is able to scan out."

SPLASH_MGK_CUSTOM_OPTION ??= "-flip"
SPLASH_MGK_CUSTOM_OPTION[doc] = "Custom options to be injected into ImageMagick's commandline, predefined for i.MX hardware."

SPLASH_DATADIR ??= "${datadir}/platsch"
SPLASH_DATADIR[doc] = "Directory where the converted images will be installed."

DEPENDS = "imagemagick-native"

# Remove and re-create ${B} so that it is guaranteed to be empty as otherwise
# the glob expression in do_install() would probably install out-of-date
# leftovers from older runs of the recipe using this class.
do_compile[cleandirs] = "${B}"

platsch_do_compile() {
    for IMG in ${SPLASH_IMAGES}; do
        # filename has to be <base>-<width>x<height>.<extension>
        echo $IMG | sed -E -e "s/(.*)-(.*)x(.*)\.(.*)/\1 \2 \3 \4/" |
        {
            read BASE WIDTH HEIGHT EXT
            if [ -z "${BASE}" -o -z "${WIDTH}" -o -z "${HEIGHT}" -o -z "${EXT}" ]; then
                bbfatal "platsch.bbclass: filename \"${IMG}\" does not satisfy scheme <base>-<width>x<height>.<extension>: BASE=\"${BASE}\", WIDTH=\"${WIDTH}\", HEIGHT=\"${HEIGHT}\", EXT=\"${EXT}\"."
            fi

            env MAGICK_CONFIGURE_PATH=${RECIPE_SYSROOT_NATIVE}/etc/ImageMagick-7 identify.im7 \
                -format "%w %h\n" ${WORKDIR}/${IMG} |
            {
                read MGK_WIDTH MGK_HEIGHT
                if [ "${WIDTH}" != "${MGK_WIDTH}" -o "${HEIGHT}" != "${MGK_HEIGHT}" ]; then
                    bbfatal "platsch.bbclass: geometry encoded in filename \"${IMG}\" does not match geometry ${MGK_WIDTH}x${MGK_HEIGHT} found in file contents."
                fi
            }

            case ${SPLASH_FORMAT} in
            RGB565)
                # HACK: a quite compact way to create a bitmap in the RGB565 format is to
                # let ImageMagick convert the source into its known BMP subtype RGB565 and
                # to strip the BMP header by only using the final width * height * (5+6+5)/8
                # bytes. For the i.MX6/i.MX8 the bitmap needs to be flipped (see [1]). This
                # is done via the bitbake parameter SPLASH_MGK_CUSTOM_OPTION (see [2]). As
                # the BMP format stores potential color profiles behind the desired pixel
                # array at the end of the file those particularly need to be dropped before
                # by the option "-strip" to let the hack succeed (see [3]). Explicitly
                # request an RGB format to avoid color map and alpha channel (via asking for
                # the TrueColor type, see [4]).
                #
                # [1] https://github.com/pengutronix/meta-ptx/pull/117#issuecomment-1474786927
                # [2] https://imagemagick.org/script/command-line-options.php#flip
                # [3] https://imagemagick.org/script/command-line-options.php#strip
                # [4] https://imagemagick.org/script/command-line-options.php#type
                #
                SIZE_OF_RAW_BITMAP=$(expr ${WIDTH} "*" ${HEIGHT} "*" "(" 5 + 6 + 5 ")" / 8)
                env MAGICK_CONFIGURE_PATH=${RECIPE_SYSROOT_NATIVE}/etc/ImageMagick-7 magick.im7 \
                    ${WORKDIR}/${IMG} ${SPLASH_MGK_CUSTOM_OPTION} \
                    -strip -type TrueColor -define bmp:subtype=${SPLASH_FORMAT} bmp:- | \
                    tail -c ${SIZE_OF_RAW_BITMAP} > ${B}/${BASE}-${WIDTH}x${HEIGHT}-${SPLASH_FORMAT}.bin
                ;;
            XRGB8888)
                # HACK: a quite compact way to create a bitmap in the XRGB8888 format is to
                # let ImageMagick convert the source into its known BMP subtype XRGB8888 and
                # to strip the BMP header by only using the final width * height * (8+8+8+8)/8
                # bytes. For the i.MX6/i.MX8 the bitmap needs to be flipped (see [1]). This
                # is done via the bitbake parameter SPLASH_MGK_CUSTOM_OPTION (see [2]). As
                # the BMP format stores potential color profiles behind the desired pixel
                # array at the end of the file those particularly need to be dropped before
                # by the option "-strip" to let the hack succeed (see [3]). Explicitly
                # request an XRGB format to avoid a color map (via asking for the TrueColor-
                # Alpha type, see [4]).
                #
                # [1] https://github.com/pengutronix/meta-ptx/pull/117#issuecomment-1474786927
                # [2] https://imagemagick.org/script/command-line-options.php#flip
                # [3] https://imagemagick.org/script/command-line-options.php#strip
                # [4] https://imagemagick.org/script/command-line-options.php#type
                #
                SIZE_OF_RAW_BITMAP=$(expr ${WIDTH} "*" ${HEIGHT} "*" "(" 8 + 8 + 8 + 8 ")" / 8)
                env MAGICK_CONFIGURE_PATH=${RECIPE_SYSROOT_NATIVE}/etc/ImageMagick-7 magick.im7 \
                    ${WORKDIR}/${IMG} ${SPLASH_MGK_CUSTOM_OPTION} \
                    -strip -type TrueColorAlpha -define bmp:subtype=${SPLASH_FORMAT} bmp:- | \
                    tail -c ${SIZE_OF_RAW_BITMAP} > ${B}/${BASE}-${WIDTH}x${HEIGHT}-${SPLASH_FORMAT}.bin
                ;;
            *)
                bbfatal "platsch.bbclass: unknown SPLASH_FORMAT \"${SPLASH_FORMAT}\"."
                ;;
            esac

            # Help the developer of a converter to a new target format with a good error
            # message.
            if [ -z "${SIZE_OF_RAW_BITMAP}" ]; then
                bbfatal "platsch.bbclass: forgot to calculate SIZE_OF_RAW_BITMAP in above case clause for SPLASH_FORMAT \"${SPLASH_FORMAT}\"."
            fi

            # Sanity check that the size of the raw bitmap is as predicted (this e.g.
            # spotlighted that ImageMagick per default converts color-mapped bitmaps to
            # color-mapped bitmaps and thereby led to the introduction of option "-type
            # TrueColor").
            FILESIZE=$(stat --format="%s" -- ${B}/${BASE}-${WIDTH}x${HEIGHT}-${SPLASH_FORMAT}.bin)
            if [ "${FILESIZE}" -ne "${SIZE_OF_RAW_BITMAP}" ]; then
                bbfatal "platsch.bbclass: FILESIZE=${FILESIZE} while SIZE_OF_RAW_BITMAP=${SIZE_OF_RAW_BITMAP} - something is fishy in the conversion of \"${IMG}\"!"
            fi
        }
    done
}

platsch_do_install() {
    # Take care to only call 'install' if there are adequately formatted bitmaps as
    # otherwise the second invocation of 'install' would fail. This is equivalent to
    # the following wildcard pattern expanding to something different:
    if [ "$(echo ${B}/*-${SPLASH_FORMAT}.bin)" != "${B}/*-${SPLASH_FORMAT}.bin" ]; then
        install -d ${D}${SPLASH_DATADIR}
        install -m 0644 ${B}/*-${SPLASH_FORMAT}.bin ${D}${SPLASH_DATADIR}
    else
        bbwarn "platsch.bbclass: no converted bitmap found for installation - is that intended?"
    fi
}

EXPORT_FUNCTIONS do_compile do_install

FILES:${PN} += " \
    ${SPLASH_DATADIR}/*-${SPLASH_FORMAT}.bin \
"
