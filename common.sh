# not executable
# common variables

ZONE=udp53.cz.
EZONE=ecdsa.cz.

KNOT_CONF=/etc/knot/knot.conf.parent-ttl
NSD_CONF=/etc/nsd/nsd.conf.parent-ttl

ZONEDIR="/etc/parent-ttl/zones/"

HOSTMASTER="ondrej@sury.org"

TAG=parent-ttl

TTL=18000

NO_TTL=0
LOW_TTL=$((60*60))
HIGH_TTL=$((24*$LOW_TTL))
MAX_TTL=$((30*$HIGH_TTL))

A=203.0.113.1
AAAA=2001:DB8::1

NS1="ns1."
NS2="ns2."

NS1_MIN_A=89.187.130.13
NS1_MIN_AAAA=2a01:5f0:c001:113:a::13
NS2_MIN_A=$NS1_MIN_A
NS2_MIN_AAAA=$NS1_MIN_AAAA

NS1_NOMIN_A=89.187.130.14
NS1_NOMIN_AAAA=2a01:5f0:c001:113:a::14
NS2_NOMIN_A=$NS1_MIN_A
NS2_NOMIN_AAAA=$NS1_MIN_AAAA

SERIAL=$(date +%s)
