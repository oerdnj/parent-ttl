#!/bin/sh

. "$(dirname ${0})/common.sh"

cd /var/lib/knot/keys
for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		keymgr zone key ds "${owner}" +active | grep -E "[[:space:]]*DS.*[[:space:]]2[[:space:]]"
	    done
	done
    done
done
