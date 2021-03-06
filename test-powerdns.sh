#!/bin/sh

. "$(dirname ${0})/common.sh"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		pdns_recursor --minimum-ttl-override=30 --dnssec=validate --local-address=::1 --local-port=${PDNS_RECURSOR_PORT} --socket-dir=. --packetcache-ttl=0 --max-cache-ttl="${MAX_TTL}" >logs/pdns_recursor-${owner}out 2>logs/pdns_recursor-${owner}err&
		PDNS_RECURSOR_PID=$!
		sleep 1
		$DIG $DIG_PARAMS +noall +rec -t A "${owner}" -p "${PDNS_RECURSOR_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t AAAA "${owner}" -p "${PDNS_RECURSOR_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t MX "${owner}" -p "${PDNS_RECURSOR_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t A "www.${owner}" -p "${PDNS_RECURSOR_PORT}" @::1
		$DIG $DIG_PARAMS +noall +rec -t AAAA "www.${owner}" -p "${PDNS_RECURSOR_PORT}" @::1
		TTL=$($DIG $DIG_PARAMS +noall +answer +authority +norec -t NS "${owner}" -p "${PDNS_RECURSOR_PORT}" @::1 | grep "${owner}" | tr -s " \t" " " | cut -f 2 -d " " | sort -u)
		$DIG $DIG_PARAMS +noall +rec -t NS "${owner}" -p "${PDNS_RECURSOR_PORT}" @::1
		TTL2=$($DIG $DIG_PARAMS +noall +answer +authority +norec -t NS "${owner}" -p "${PDNS_RECURSOR_PORT}" @::1 | grep "${owner}" | tr -s " \t" " " | cut -f 2 -d " " | sort -u)
		kill -TERM $PDNS_RECURSOR_PID
		printf "%s:%s:%s:%s\n" "powerdns" "${owner}" "${TTL}" "${TTL2}"
	    done
	done
    done
done
