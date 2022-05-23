#!/bin/ash

## https://openwrt.org/docs/guide-user/services/dns/dot_dnsmasq_stubby
## https://github.com/openwrt/packages/blob/master/net/stubby/files/README.md

uci set stubby.global.dnssec_return_status=1
uci set stubby.global.appdata_dir="/tmp/stubby"
uci set stubby.global.round_robin_upstreams="0"
uci set stubby.global.idle_timeout="5000"
uci set stubby.global.tls_backoff_time="3600"
uci set stubby.global.tls_connection_retries="1"
uci set stubby.global.tls_min_version="1.3" ## yes, that's right.
uci set stubby.global.tls_max_version="1.3"
uci -q delete stubby.global.listen_address
uci add_list stubby.global.listen_address="127.0.0.2@53053"

while uci -q delete stubby.@resolver[0]; do :; done
uci set stubby.dns6a="resolver"
uci set stubby.dns6a.address="2001:4860:4860::8888"
uci set stubby.dns6a.tls_auth_name="dns.google"
uci set stubby.dns6b="resolver"
uci set stubby.dns6b.address="2001:4860:4860::8844"
uci set stubby.dns6b.tls_auth_name="dns.google"
uci set stubby.dnsa="resolver"
uci set stubby.dnsa.address="8.8.8.8"
uci set stubby.dnsa.tls_auth_name="dns.google"
uci set stubby.dnsb="resolver"
uci set stubby.dnsb.address="8.8.4.4"
uci set stubby.dnsb.tls_auth_name="dns.google"

uci commit stubby
/etc/init.d/stubby restart
/etc/init.d/stubby enable
