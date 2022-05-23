#!/bin/ash
/etc/init.d/dnsmasq stop
uci set dhcp.@dnsmasq[0].noresolv="1"
uci set dhcp.@dnsmasq[0].cachesize="0"
uci -q delete dhcp.@dnsmasq[0].server
uci -q delete dhcp.@dnsmasq[0].doh_backup_server
#uci add_list dhcp.@dnsmasq[0].server="127.0.0.2#53053"
uci add_list dhcp.@dnsmasq[0].server="127.0.0.2#53153"
uci commit dhcp
/etc/init.d/dnsmasq restart
