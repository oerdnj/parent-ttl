#!/bin/sh

ZONE=udp53.cz.
EZONE=ecdsa.cz.

TAG=parent

TTL=18000

A=203.0.113.1
AAAA=2001:DB8::1

NS1=""
NS2="ns."

NS1_MIN_A=89.187.130.13
NS1_MIN_AAAA=2a01:5f0:c001:113:a::13
NS2_MIN_A=$NS1_MIN_A
NS2_MIN_AAAA=$NS1_MIN_AAAA

NS1_NOMIN_A=89.187.130.14
NS1_NOMIN_AAAA=2a01:5f0:c001:113:a::14
NS2_NOMIN_A=$NS1_MIN_A
NS2_NOMIN_AAAA=$NS1_MIN_AAAA

printf "${NS1}min-in-bailiwick.$ZONE\tIN\tA\t$NS1_MIN_A\n"
printf "${NS1}min-in-bailiwick.$ZONE\tIN\tAAAA\t$NS1_MIN_AAAA\n"
printf "${NS2}min-in-bailiwick.$ZONE\tIN\tA\t$NS2_MIN_A\n"
printf "${NS2}min-in-bailiwick.$ZONE\tIN\tAAAA\t$NS2_MIN_AAAA\n"
printf "${NS1}nomin-in-bailiwick.$ZONE\tIN\tA\t$NS1_NOMIN_A\n"
printf "${NS1}nomin-in-bailiwick.$ZONE\tIN\tAAAA\t$NS1_NOMIN_AAAA\n"
printf "${NS2}nomin-in-bailiwick.$ZONE\tIN\tA\t$NS2_NOMIN_A\n"
printf "${NS2}nomin-in-bailiwick.$ZONE\tIN\tAAAA\t$NS2_NOMIN_AAAA\n"

for ttl in no low high max; do
    for amin in min nomin; do	
	for dnssec in dnssec nodnssec; do
	    for nstype in in-bailiwick in-domain external; do
		owner="$TAG-$ttl-$amin-$dnssec-$nstype.$ZONE"
		printf "$owner\t$TTL\tIN\tA\t$A\n"
		printf "$owner\t$TTL\tIN\tAAAA\t$AAAA\n"
		case $nstype in
		    in-bailiwick)
			printf "$owner\t$TTL\tIN\tNS\t${NS1}$amin-in-bailiwick.$ZONE\n"
			printf "$owner\t$TTL\tIN\tNS\t${NS2}$amin-in-bailiwick.$ZONE\n"
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
			printf "$owner\t$TTL\tIN\tNS\t${NS1}$amin-external.$EZONE\n"
			printf "$owner\t$TTL\tIN\tNS\t${NS2}$amin-external.$EZONE\n"
			;;
		esac
	    done
	done
    done
done
