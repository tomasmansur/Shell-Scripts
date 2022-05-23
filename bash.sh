ftp -inv $HOST << EOF
user $USER $PASS
get $FILENAME
bye
EOF
