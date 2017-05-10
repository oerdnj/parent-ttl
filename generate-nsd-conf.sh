#!/bin/sh

. "$(dirname ${0})/common.sh"

: > "${NSD_CONF}"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		printf "zone:\n" >> "${NSD_CONF}"
		printf "\tname: ${owner}\n" >> "${NSD_CONF}"
		case "${dnssec}" in
		    dnssec)
			printf "\tzonefile: ${ZONEDIR}/${owner}.signed\n\n" >> "${NSD_CONF}"
			rm -f "${ZONEDIR}${owner}.signed"
			rm -f "${ZONEDIR}K${owner}*"
			/usr/sbin/dnssec-keygen -v 0 -K "${ZONEDIR}" -a ECDSAP256SHA256 -f KSK -r /dev/urandom "${owner}"
			/usr/sbin/dnssec-keygen -v 0 -K "${ZONEDIR}" -a ECDSAP256SHA256 -r /dev/urandom "${owner}"
			/usr/sbin/dnssec-signzone -v 0 -S -N keep -K "${ZONEDIR}" -o "${owner}" "${ZONEDIR}${owner}"
			;;
		    nodnssec)
			printf "\tzonefile: ${ZONEDIR}/${owner}\n\n" >> "${NSD_CONF}"
			;;
		esac
	    done
	done
    done
done
