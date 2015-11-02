require rauc.inc
PR = "r9"

SRC_URI_append = " \ 
	git://github.com/jluebbe/rauc.git;protocol=https \
	"

PV = "0+git${SRCPV}"
S = "${WORKDIR}/git"

SRCREV = "64d5fc76a7a1ada521b56fbe58534a7e9a7c14e3"
