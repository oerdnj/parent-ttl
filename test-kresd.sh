#!/bin/sh

. "$(dirname ${0})/common.sh"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
		while true; do
	       	    owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		    rm *.mdb
		    kresd -k /usr/share/dns/root.key -f 1 -v -a 127.0.0.1#${KRESD_PORT} -a ::1#${KRESD_PORT} >logs/kresd-${owner}out 2>logs/kresd-${owner}err&
		    KRESD_PID=$!
		    sleep 1
		    kdig +noall +rec -t A "${owner}" -p "${KRESD_PORT}" @::1
		    kdig +noall +rec -t AAAA "${owner}" -p "${KRESD_PORT}" @::1
		    kdig +noall +rec -t MX "${owner}" -p "${KRESD_PORT}" @::1
		    kdig +noall +rec -t A "www.${owner}" -p "${KRESD_PORT}" @::1
		    kdig +noall +rec -t AAAA "www.${owner}" -p "${KRESD_PORT}" @::1
#		    printf 'cache.peek_rr("%s", kres.type.NS):tolist()\n' "${owner}" | socat - UNIX-CONNECT:tty/${KRESD_PID}
		    TTL=$(printf 'cache.peek_rr("%s", kres.type.NS):tolist()\n' "${owner}" | socat - UNIX-CONNECT:tty/${KRESD_PID} 2>/dev/null | sed -ne "s,.*\\[ttl\\] => ,,gp" | sort -u)
		    kdig +noall +rec -t NS "${owner}" -p "${KRESD_PORT}" @::1
#		    printf 'cache.peek_rr("%s", kres.type.NS):tolist()\n' "${owner}" | socat - UNIX-CONNECT:tty/${KRESD_PID}
		    TTL2=$(printf 'cache.peek_rr("%s", kres.type.NS):tolist()\n' "${owner}" | socat - UNIX-CONNECT:tty/${KRESD_PID} 2>/dev/null | sed -ne "s,.*\\[ttl\\] => ,,gp" | sort -u)
		    if [ -n "${TTL}" ] && [ -n "${TTL2}" ]; then
			printf "%s:%s:%s\n" "${owner}" "${TTL}" "${TTL2}"
			break
		    fi
		done
	    done
	done
    done
done