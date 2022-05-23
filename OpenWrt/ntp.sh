#!/bin/ash

/etc/init.d/sysntpd stop

#uci set system.ntp=timeserver
uci set system.ntp.enabled="1"
uci set system.ntp.enable_server="1"
uci -q delete system.ntp.server
uci add_list system.ntp.server="time1.google.com"
uci add_list system.ntp.server="time2.google.com"
uci add_list system.ntp.server="time3.google.com"
uci add_list system.ntp.server="time4.google.com"

uci commit system
/etc/init.d/sysntpd restart
