#!/bin/ash

## wifi-device
uci set wireless.radio$1.disabled='0'
uci set wireless.radio$1.htmode='HT20'
uci set wireless.radio$1.hwmode='11g'
uci set wireless.radio$1.country='AR' ## Argentina.
uci set wireless.radio$1.channel='auto'
## wifi-iface
uci set wireless.default_radio$1.mode='ap'
uci set wireless.default_radio$1.ssid=
uci set wireless.default_radio$1.encryption='psk2+aes'
uci set wireless.default_radio$1.key=

uci commit wireless
wifi reload
