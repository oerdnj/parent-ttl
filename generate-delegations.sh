#!/bin/sh

. "$(dirname ${0})/common.sh"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
		owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		printf "$owner\t$TTL\tIN\tA\t$A\n"
		printf "$owner\t$TTL\tIN\tAAAA\t$AAAA\n"
		case $nstype in
		    in-bailiwick)
			printf "$owner\t$TTL\tIN\tNS\t${NS1}$TAG-$ttl-$amin-$dnssec-in-domain.$ZONE\n"
			printf "$owner\t$TTL\tIN\tNS\t${NS2}$TAG-$ttl-$amin-$dnssec-in-domain.$ZONE\n"
			;;
		    in-domain)
			printf "$owner\t$TTL\tIN\tNS\t${NS1}$owner\n"
			printf "$owner\t$TTL\tIN\tNS\t${NS2}$owner\n"
			case $amin in
			    min)
				printf "${NS1}$owner\t$TTL\tIN\tA\t$NS1_MIN_A\n"
				printf "${NS1}$owner\t$TTL\tIN\tAAAA\t$NS1_MIN_AAAA\n"
				printf "${NS2}$owner\t$TTL\tIN\tA\t$NS2_MIN_A\n"
				printf "${NS2}$owner\t$TTL\tIN\tAAAA\t$NS2_MIN_AAAA\n"
				;;
			    nomin)
				printf "${NS1}$owner\t$TTL\tIN\tA\t$NS1_NOMIN_A\n"
				printf "${NS1}$owner\t$TTL\tIN\tAAAA\t$NS1_NOMIN_AAAA\n"
				printf "${NS2}$owner\t$TTL\tIN\tA\t$NS2_NOMIN_A\n"
				printf "${NS2}$owner\t$TTL\tIN\tAAAA\t$NS2_NOMIN_AAAA\n"
				;;
			esac
			;;
		    external)
			printf "$owner\t$TTL\tIN\tNS\t${NS1}$TAG-$ttl-$amin-$dnssec-external.$EZONE\n"
			printf "$owner\t$TTL\tIN\tNS\t${NS2}$TAG-$ttl-$amin-$dnssec-external.$EZONE\n"
			;;
		esac
	    done
	done
    done
done
