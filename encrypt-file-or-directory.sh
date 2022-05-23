#!/bin/bash
tar -cf $1.tar $1
7z a -p -mhe=on $1.tar.7z $1.tar
