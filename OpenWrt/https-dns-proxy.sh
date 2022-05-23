#!/bin/ash

uci -q delete https-dns-proxy.@main[0].force_dns_port
uci set https-dns-proxy.config.update_dnsmasq_config='-'
uci set https-dns-proxy.config.force_dns="0"

# Configure DoH provider
while uci -q delete https-dns-proxy.@https-dns-proxy[0]; do :; done
uci set https-dns-proxy.dns="https-dns-proxy"
uci set https-dns-proxy.dns.bootstrap_dns="8.8.8.8,8.8.4.4,"#2001:4860:4860::8888,2001:4860:4860::8844"
uci set https-dns-proxy.dns.resolver_url="https://dns.google/dns-query"
uci set https-dns-proxy.dns.listen_addr="127.0.0.2"
uci set https-dns-proxy.dns.listen_port="53153"
uci set https-dns-proxy.dns.user="nobody"
uci set https-dns-proxy.dns.group="nogroup"

uci commit https-dns-proxy
/etc/init.d/https-dns-proxy enable
/etc/init.d/https-dns-proxy restart
