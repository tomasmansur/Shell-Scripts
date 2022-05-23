#!/bin/ash
uci set network.lan.ipaddr='10.0.0.1'
uci set network.wan.peerdns='0'
uci set network.wan.dns='127.0.0.1'
uci set network.wan6.peerdns='0'
uci set network.wan6.dns='127.0.0.1' ## or ::1
uci commit network
/etc/init.d/network restart
