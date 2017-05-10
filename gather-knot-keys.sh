#!/bin/sh

. "$(dirname ${0})/common.sh"

cd /var/lib/knot/keys
for ttl in no low high max; do
    for amin in min; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		keymgr zone key ds "${owner}" +active | grep DS
	    done
	done
    done
done
