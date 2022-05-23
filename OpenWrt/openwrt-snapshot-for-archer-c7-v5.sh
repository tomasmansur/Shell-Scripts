#!/bin/bash

## https://openwrt.org/docs/guide-user/additional-software/imagebuilder#prerequisites

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

apt update -qq
apt install -y build-essential libncurses5-dev libncursesw5-dev \
zlib1g-dev gawk git gettext libssl-dev xsltproc rsync wget unzip

mkdir --parents /opt/openwrt-snapshots
rm -rf /opt/openwrt-snapshots/archer-c7-v5

if [[ $(wget -q --spider https://downloads.openwrt.org/snapshots/targets/ath79/generic/openwrt-imagebuilder-ath79-generic.Linux-x86_64.tar.xz) -eq "0" ]]; then
    wget --https-only --inet4-only https://downloads.openwrt.org/snapshots/targets/ath79/generic/openwrt-imagebuilder-ath79-generic.Linux-x86_64.tar.xz
    tar -J -x -f openwrt-imagebuilder-ath79-generic.Linux-x86_64.tar.xz
    rm -rf openwrt-imagebuilder-ath79-generic.Linux-x86_64.tar.xz
    cd openwrt-imagebuilder-ath79-generic.Linux-x86_64/
    source ../packages.sh
    PROFILE_="tplink_archer-c7-v5"
    BIN_DIR_="/opt/openwrt-snapshots/archer-c7-v5"
    rm -rf $BIN_DIR_
    make image PROFILE=$PROFILE_ PACKAGES="$PACKAGES_" BIN_DIR=$BIN_DIR_
    make clean
    cd ..
    rm -rf openwrt-imagebuilder-ath79-generic.Linux-x86_64/
fi
