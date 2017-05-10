#!/bin/sh

. "$(dirname ${0})/common.sh"

mkdir -p "${ZONEDIR}"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
	       	owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		case $nstype in
		    in-bailiwick)
			NS_ZONE="$TAG-$ttl-$amin-$dnssec-in-domain.$ZONE"
			;;
		    in-domain)
			NS_ZONE="${owner}"
			;;
		    external)
			NS_ZONE="$TAG-$ttl-$amin-$dnssec-external.$EZONE"
			;;
		esac
		case "${ttl}" in
		    no) TTL=$NO_TTL;;
		    low) TTL=$LOW_TTL;;
		    high) TTL=$HIGH_TTL;;
		    max) TTL=$MAX_TTL;;
		esac
		zonefile="${ZONEDIR}/${owner}"
		: > "${zonefile}"
		printf "$owner\t$TTL\tIN\tSOA\t${NS1}${NS_ZONE} ${HOSTMASTER} ${SERIAL} 86400 7200 3600000 ${TTL}\n" >> "${zonefile}"
		printf "$owner\t$TTL\tIN\tNS\t${NS1}${NS_ZONE}\n" >> "${zonefile}"
		printf "$owner\t$TTL\tIN\tNS\t${NS2}${NS_ZONE}\n" >> "${zonefile}"
		printf "$owner\t$TTL\tIN\tMX\t0 .\n" >> "${zonefile}"
		printf "$owner\t$TTL\tIN\tA\t$A\n" >> "${zonefile}"
		printf "$owner\t$TTL\tIN\tAAAA\t$AAAA\n" >> "${zonefile}"
		printf "www.$owner\t$TTL\tIN\tA\t$A\n" >> "${zonefile}"
		printf "www.$owner\t$TTL\tIN\tAAAA\t$AAAA\n" >> "${zonefile}"
		if [ "${nstype}" = "in-domain" ]; then
		    case $amin in
			nomin)
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tA\t$NS1_NOMIN_A\n" >> "${zonefile}"
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS1_NOMIN_AAAA\n" >> "${zonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tA\t$NS2_NOMIN_A\n" >> "${zonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS2_NOMIN_AAAA\n" >> "${zonefile}"
			    ;;
			min)
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tA\t$NS1_MIN_A\n" >> "${zonefile}"
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS1_MIN_AAAA\n" >> "${zonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tA\t$NS2_MIN_A\n" >> "${zonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS2_MIN_AAAA\n" >> "${zonefile}"
			    ;;
		    esac
		fi
		if [ "${nstype}" = "external" ]; then
		    eowner="$TAG-$ttl-$amin-$dnssec-$nstype.$EZONE"
		    ezonefile="${ZONEDIR}/${eowner}"
		    printf "$owner\t$TTL\tIN\tSOA\t${NS1}${NS_ZONE} ${HOSTMASTER} ${SERIAL} 86400 7200 3600000 ${TTL}\n" >> "${ezonefile}"
		    printf "$owner\t$TTL\tIN\tNS\t${NS1}${NS_ZONE}\n" >> "${ezonefile}"
		    printf "$owner\t$TTL\tIN\tNS\t${NS2}${NS_ZONE}\n" >> "${ezonefile}"
		    printf "$owner\t$TTL\tIN\tMX\t0 .\n" >> "${ezonefile}"
		    case $amin in
			nomin)
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tA\t$NS1_NOMIN_A\n" >> "${ezonefile}"
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS1_NOMIN_AAAA\n" >> "${ezonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tA\t$NS2_NOMIN_A\n" >> "${ezonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS2_NOMIN_AAAA\n" >> "${ezonefile}"
			    ;;
			min)
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tA\t$NS1_MIN_A\n" >> "${ezonefile}"
			    printf "${NS1}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS1_MIN_AAAA\n" >> "${ezonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tA\t$NS2_MIN_A\n" >> "${ezonefile}"
			    printf "${NS2}${NS_ZONE}\t$TTL\tIN\tAAAA\t$NS2_MIN_AAAA\n" >> "${ezonefile}"
			    ;;
		    esac
		fi
	    done
	done
    done
done
