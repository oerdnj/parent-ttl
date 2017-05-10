#!/bin/sh

. "$(dirname ${0})/common.sh"

cat > "${KNOT_CONF}" <<EOF
policy:
  - id: dnssec
    algorithm: ecdsap256sha256

template:
  - id: nodnssec
    dnssec-signing: off
    serial-policy: "unixtime"
    file: "${ZONEDIR}%s."
    zonefile-sync: 0

template:
  - id: dnssec
    dnssec-signing: on
    dnssec-policy: dnssec
    serial-policy: "unixtime"
    file: "${ZONEDIR}%s."
    zonefile-sync: 0

zone:
EOF

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		printf "  - domain: $owner\n" >> "${KNOT_CONF}"
		printf "    template: $dnssec\n" >> "${KNOT_CONF}"
	    done
	done
    done
done
