#!/bin/sh

. "$(dirname ${0})/common.sh"

printf 'cache.clear()' > config
for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		printf 'resolve("%s", kres.type.A, kres.class.IN, kres.query.CACHED)\n' "${owner}" >> config
		printf 'resolve("%s", kres.type.AAAA, kres.class.IN, kres.query.CACHED)\n' "${owner}" >> config
		printf 'resolve("%s", kres.type.MX, kres.class.IN, kres.query.CACHED)\n' "${owner}" >> config
		printf 'resolve("www.%s", kres.type.A, kres.class.IN, kres.query.CACHED)\n' "${owner}" >> config
		printf 'resolve("www.%s", kres.type.AAAA, kres.class.IN, kres.query.CACHED)\n' "${owner}" >> config
	    done
	done
    done
done

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		printf 'cache.peek_rr("%s", kres.type.NS):tolist()\n' "${owner}"
	    done
	done
    done
done
