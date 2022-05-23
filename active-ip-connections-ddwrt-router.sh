#echo $(( $(grep -c ^udp /proc/net/ip_conntrack) + $(grep -c ^tcp /proc/net/ip_conntrack) ))

#MAX_IP=$(cat /proc/sys/net/ipv4/netfilter/ip_conntrack_max)
TCP_TIMEOUT=$(cat /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established)
UDP_TIMEOUT=$(cat /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout_stream)

ACTUAL_TCP=$(grep -c ^tcp /proc/net/ip_conntrack)
ACTUAL_UDP=$(grep -c ^udp /proc/net/ip_conntrack)
ACTUAL_TOTAL=$(( $ACTUAL_TCP + $ACTUAL_UDP ))

echo -e "Actual TCP connections: \t"$ACTUAL_TCP
echo -e "Actual UDP connections: \t"$ACTUAL_UDP
echo -e "Actual total IP connections: \t"$ACTUAL_TOTAL
