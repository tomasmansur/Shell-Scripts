home_server_hostname_changer()
{
	#changing mac address at every startup it is not enough... network administrators can track your computer anyway trough the hostname...
	#so lets change hostname at every startup (with systemd):
	## https://linuxconfig.org/how-to-automatically-execute-shell-script-at-startup-boot-on-systemd-linux
	echo "#!/bin/bash

STRING='SERVER'
head /dev/urandom > /tmp/r
R_STRING=\$(cat /tmp/r | tr -dc '0-9' | fold -w \${1:-13} | head -n 1)
NEW_HOSTNAME=\$STRING-\$R_STRING #example: SERVER-2457824658356
OLD_HOSTNAME=\$(hostname)
hostnamectl set-hostname \$NEW_HOSTNAME
sed -i s/\$OLD_HOSTNAME/\$NEW_HOSTNAME/g /etc/hosts
rm -rf /tmp/r
	" > /sbin/hostname-changer.sh
	chmod u+x /sbin/hostname-changer.sh
	echo "[Unit]
Description=Change the hostname at startup.

[Service]
ExecStart=bash /sbin/hostname-changer.sh

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/hostname-changer.service
	systemctl daemon-reload
	systemctl enable hostname-changer
}

mac_address_spoofing()
{
	#Now it's time to configure permanent random mac address for every wifi adaptaer card and wired card connected to pc at boot time thanks to systemd-networkd.
	#systemd-networkd supports MAC address spoofing via link files (see systemd.link(5) for details).
	# https://wiki.archlinux.org/index.php/MAC_address_spoofing
	#mac addresses of:
	apt update
	apt install ethtool -y #this tool will get hardware mac address of device.
	INTERFACES=$(ls /sys/class/net/)
	INTERFACES=${INTERFACES/lo}
	FILE=/etc/systemd/network/00-default.link
	COMMAND=ethtool
	if test -f "$FILE"
	then
		cp $FILE $FILE.backup
	fi
	rm -rf $FILE
	touch $FILE
	if ! command -v $COMMAND &> /dev/null #Why this? In case offline configuration or apt didn't get the package, else procede with ethtool command.
	then
    	echo "ethtool software cannot be executed for some reason..."
		echo "adding mac address of local host by /sys/class/net/*/address on 00-default.link file..."
		echo "[Match]
		" > $FILE
		for i in $INTERFACES
		do
			MAC_ADDRESS=$(cat /sys/class/net/$i/address)
			echo "MACAddress=$MAC_ADDRESS" >> $FILE
			echo "$MAC_ADDRESS added."
		done
		echo "
[Link]
MACAddressPolicy=random
NamePolicy=kernel database onboard slot path" >> $FILE
	else
    	echo "[Match]
		" > $FILE
		for i in $INTERFACES
		do
			MAC_ADDRESS=$(ethtool -P $i)
			MAC_ADDRESS=${MAC_ADDRESS:19:17}
			echo "MACAddress=$MAC_ADDRESS" >> $FILE
		done
		echo "
[Link]
MACAddressPolicy=random
NamePolicy=kernel database onboard slot path" >> $FILE
	fi
	#systemctl enable systemd-networkd
}

ntp_config()
{
	if true #[ "test -f /etc/systemd/timesyncd.conf" = "0" ]
	then
		cp /etc/systemd/timesyncd.conf /etc/systemd/timesyncd.conf.backup
		sed -i '/#NTP=/!b;cNTP=time.google.com' /etc/systemd/timesyncd.conf
		sed -i '/FallbackNTP/!b;cFallbackNTP=time1.google.com time2.google.com time3.google.com time4.google.com' /etc/systemd/timesyncd.conf
		#sed -i s/#RootDistanceMaxSec/RootDistanceMaxSec/g /etc/systemd/timesyncd.conf
		#sed -i s/#PollIntervalMinSec/PollIntervalMinSec/g /etc/systemd/timesyncd.conf
		#sed -i s/#PollIntervalMaxSec/PollIntervalMaxSec/g /etc/systemd/timesyncd.conf
		systemctl daemon-reload
		systemctl restart systemd-timesyncd
	fi
}

static_private_ipv4_address()
{
	FILE=/etc/network/interfaces.d/eth0
	cp $FILE /root/eth0.backup
	echo "auto eth0
iface eth0 inet static
	address 10.0.0.200
	netmask 255.255.255.0
	broadcast 10.0.0.255
	gateway 10.0.0.1
	dns-nameservers 127.0.0.1
iface eth0 inet6 dhcp" > $FILE
}

apt_trough_local_tor_socks5_proxy()
{
	FILE=/etc/apt/apt.conf.d/02proxy
	echo 'Acquire::http::Proxy "socks5h://0.0.0.0:9050";' > $FILE
	echo 'Acquire::https::Proxy "socks5h://0.0.0.0:9050";' >> $FILE
}

debian_http_repositories_to_debian_hidden_services_repositories()
{
	FILE=/etc/apt/sources.list
	cp $FILE $FILE.backup
	sed -i s/https/http/g $FILE
	sed -i s/http/https/g $FILE
	sed -i s/deb.debian.org/2s4yqjx5ul6okpp3f2gaunr2syex5jgbfpfvhxxbbjwnrsvbk5v3qbid.onion/g $FILE
	sed -i s/security.debian.org/5ajw6aqf3ep7sijnscdzw77t7xq4xjpsy335yb2wiwgouo7yfxtjlmid.onion/g $FILE
}


static_resolv_conf()
{
	echo "[Unit]
Description=Set file /etc/resolv.conf static with particular configuration

[Service]
ExecStart=bash /sbin/static-resolv-conf.sh

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/static-resolv-conf.service
	echo "chattr -i /etc/resolv.conf
echo 'nameserver 0.0.0.0' > /etc/resolv.conf
chattr +i /etc/resolv.conf" > /sbin/static-resolv-conf.sh
	chmod u+x /sbin/static-resolv-conf.sh
	systemctl daemon-reload
	systemctl restart static-resolv-conf
	systemctl enable static-resolv-conf
}

openssh_server_reconfiguration()
{
	FILE=/etc/ssh/sshd_config
	cp $FILE $FILE.backup
	#systemctl stop ssh
	#sed -i '/PermitRootLogin/!b;cPermitRootLogin yes' $FILE
	#echo "PermitEmptyPassword yes" >> $FILE
	rm -v /etc/ssh/ssh_host_*
	dpkg-reconfigure openssh-server
	systemctl restart ssh
}

static_resolv_conf
apt_trough_local_tor_socks5_proxy
debian_http_repositories_to_debian_hidden_services_repositories
home_server_hostname_changer
mac_address_spoofing
ntp_config
#static_private_ipv4_address
openssh_server_reconfiguration
exit 0

