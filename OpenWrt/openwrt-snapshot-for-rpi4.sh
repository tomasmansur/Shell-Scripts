#!/bin/bash

## https://openwrt.org/docs/guide-user/additional-software/imagebuilder#prerequisites
## https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711/

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

apt update -qq
apt install -y build-essential libncurses5-dev libncursesw5-dev \
zlib1g-dev gawk git gettext libssl-dev xsltproc rsync wget unzip

mkdir --parents /opt/openwrt-snapshots
mkdir --parents /opt/openwrt-snapshots/rpi4

if [[ $(wget -q --spider https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711/openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz) -eq "0" ]]; then
    wget --https-only --inet4-only https://downloads.openwrt.org/snapshots/targets/bcm27xx/bcm2711/openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz
    tar -J -x -f openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz
    rm -rf openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64.tar.xz
    cd openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64/
    source ../packages.sh
    PROFILE_="DEVICE_rpi-4"
    BIN_DIR_="/opt/openwrt-snapshots/rpi4"
    make image PROFILE=$PROFILE_ PACKAGES="$PACKAGES_" BIN_DIR=$BIN_DIR_
    make clean
    cd ..
    rm -rf openwrt-imagebuilder-bcm27xx-bcm2711.Linux-x86_64/
fi
