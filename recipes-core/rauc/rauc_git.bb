require rauc.inc
PR = "r9"

SRC_URI_append = " \ 
	git://github.com/jluebbe/rauc.git;protocol=https \
	"

PV = "0+git${SRCPV}"
S = "${WORKDIR}/git"

SRCREV = "aece736bba159f13427feae41b4f17039f6d979f"
