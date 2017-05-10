#!/bin/sh

. "$(dirname ${0})/common.sh"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in external; do
		eowner="$TAG-$ttl-$amin-$dnssec-external.$EZONE"
		case $amin in
		    min)
			printf "${NS1}$eowner\t$TTL\tIN\tA\t$NS1_MIN_A\n"
			printf "${NS1}$eowner\t$TTL\tIN\tAAAA\t$NS1_MIN_AAAA\n"
			printf "${NS2}$eowner\t$TTL\tIN\tA\t$NS2_MIN_A\n"
			printf "${NS2}$eowner\t$TTL\tIN\tAAAA\t$NS2_MIN_AAAA\n"
			;;
		    nomin)
			printf "${NS1}$eowner\t$TTL\tIN\tA\t$NS1_NOMIN_A\n"
			printf "${NS1}$eowner\t$TTL\tIN\tAAAA\t$NS1_NOMIN_AAAA\n"
			printf "${NS2}$eowner\t$TTL\tIN\tA\t$NS2_NOMIN_A\n"
			printf "${NS2}$eowner\t$TTL\tIN\tAAAA\t$NS2_NOMIN_AAAA\n"
			;;
		esac
	    done
	done
    done
done
