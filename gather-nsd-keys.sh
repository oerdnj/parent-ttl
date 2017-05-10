#!/bin/sh

. "$(dirname ${0})/common.sh"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		dnssec-dsfromkey -2 -f "${ZONEDIR}/${owner}.signed" "${owner}"
	    done
	done
    done
done
