#!/bin/sh

. "$(dirname ${0})/common.sh"

KRESD_CONFIG=knot-resolver/config

printf 'cache.clear()\n' > "${KRESD_CONFIG}"
for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
		named -g >logs/bind-${owner}out 2>logs/bind-${owner}err&
		BIND_PID=$!
		sleep 1
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		$DIG $DIG_PARAMS +noall +rec -t A "${owner}" -p "${BIND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t AAAA "${owner}" -p "${BIND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t MX "${owner}" -p "${BIND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t A "www.${owner}" -p "${BIND_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t AAAA "www.${owner}" -p "${BIND_PORT}" @::1
		TTL=$($DIG $DIG_PARAMS +noall +answer +authority +norec -t NS "${owner}" -p "${BIND_PORT}" @::1 | grep "${owner}" | tr -s " \t" " " | cut -f 2 -d " " | sort -u)
		$DIG $DIG_PARAMS +noall +rec -t NS "${owner}" -p "${BIND_PORT}" @::1
		TTL2=$($DIG $DIG_PARAMS +noall +answer +authority +norec -t NS "${owner}" -p "${BIND_PORT}" @::1 | grep "${owner}" | tr -s " \t" " " | cut -f 2 -d " " | sort -u)
		kill -TERM $BIND_PID
		printf "%s:%s:%s:%s\n" "bind" "${owner}" "${TTL}" "${TTL2}"
	    done
	done
    done
done

