#!/bin/ash
uci set system.@system[0].timezone="<-03>3" ## /America/Argentina/Cordoba
uci commit system
/etc/init.d/cron restart
