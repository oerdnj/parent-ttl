#!/bin/sh

. "$(dirname ${0})/common.sh"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		unbound -d >logs/unbound-${owner}out 2>logs/unbound-${owner}err&
		UNBOUND_PID=$!
		sleep 1
		$DIG $DIG_PARAMS +noall +rec -t A "${owner}" -p "${UNBOUND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t AAAA "${owner}" -p "${UNBOUND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t MX "${owner}" -p "${UNBOUND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t A "www.${owner}" -p "${UNBOUND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t AAAA "www.${owner}" -p "${UNBOUND_PORT}" @::1
		TTL=$($DIG $DIG_PARAMS +noall +answer +authority +norec -t NS "${owner}" -p "${UNBOUND_PORT}" @::1 | grep "${owner}" | tr -s " \t" " " | cut -f 2 -d " " | sort -u)
		$DIG $DIG_PARAMS +noall +rec -t NS "${owner}" -p "${UNBOUND_PORT}" @::1
		TTL2=$($DIG $DIG_PARAMS +noall +answer +authority +norec -t NS "${owner}" -p "${UNBOUND_PORT}" @::1 | grep "${owner}" | tr -s " \t" " " | cut -f 2 -d " " | sort -u)
		kill -TERM $UNBOUND_PID
		printf "%s:%s:%s:%s\n" "unbound" "${owner}" "${TTL}" "${TTL2}"
	    done
	done
    done
done
