#!/bin/sh
LINKS_=/tmp/links
apt install update && apt install -y curl wget
curl -s musl.cc | grep cross > $LINKS_
wget --https-only --input-file=$LINKS_
