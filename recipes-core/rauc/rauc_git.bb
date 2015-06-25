include rauc.inc
PR = "r9"

SRC_URI_append = " \ 
	git://git-customers.pengutronix.de/rauc.git;protocol=ssh;user=gitolite \
	file://openssl-ca/dev-ca.pem "

PV = "0+git${SRCPV}"
S = "${WORKDIR}/git"

SRCREV = "7904e2e9d17fe0319bc46912e3531cf1b5ed4533"
