require rauc.inc
PR = "r9"

SRC_URI_append = " \ 
	git://github.com/jluebbe/rauc.git;protocol=https \
	"

PV = "0+git${SRCPV}"
S = "${WORKDIR}/git"

SRCREV = "933db186f15e8a90450cc63c31d525ca8169c1cf"
