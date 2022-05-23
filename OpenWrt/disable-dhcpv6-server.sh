#!/bin/ash
/etc/init.d/dnsmasq stop
uci set dhcp.lan.dhcpv6=disabled
uci set dhcp.lan.ra=disabled
uci commit dhcp
/etc/init.d/dnsmasq restart
