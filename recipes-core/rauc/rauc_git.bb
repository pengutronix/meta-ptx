require rauc.inc
PR = "r9"

SRC_URI_append = " \ 
	git://github.com/jluebbe/rauc.git;protocol=https \
	"

PV = "0+git${SRCPV}"
S = "${WORKDIR}/git"

SRCREV = "c0a637ac4d1b65ff4a78fb4499415e5797fb5153"
