#!/bin/bash

HOST="10.0.0.200"
USER="ftpuser"
PASS="123"
FILENAME="archivo-de-prueba"

ftp -inv $HOST << EOF
user $USER $PASS
get $FILENAME
bye
EOF
