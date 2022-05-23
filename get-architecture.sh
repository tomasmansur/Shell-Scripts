#!/bin/sh

check_arch()
{
    if [[ $ARCH == x86_64* ]]; then
        echo "amd64"
    elif [[ $ARCH == amd64 ]]; then
        echo "amd64"
    elif [[ $ARCH == i*86 ]]; then
        echo "i386"
    elif  [[ $ARCH == arm64 ]]; then
        echo "arm64"
    elif  [[ $ARCH == aarch64 ]]; then
        echo "arm64"
    elif  [[ $ARCH == armv8 ]]; then
        echo "arm64"
    elif  [[ $ARCH == armv7 ]]; then
        echo "armhf"
    elif  [[ $ARCH == mips ]]; then
        echo "mips"
    else
        echo "Chuck Norris"
    fi
}

hostnamectl_command()
{
    ARCH=$(hostnamectl | grep -i kernel)
}

uname_command()
{
    ARCH=$(uname -m)
}

main()
{
    export ARCH=""

    if command -v uname &> /dev/null
    then
        uname_command
    elif command -v hostnamectl &> /dev/null
        hostnamectl_command
    fi

    check_arch

}

main
exit 0
