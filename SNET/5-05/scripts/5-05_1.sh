#!/usr/bin/env bash

ROOTUSER_NAME=root
OCTET_RANGE=({0..255})

username=$(id -nu)
if [ "$username" != "$ROOTUSER_NAME" ]; then
    echo "Must be root to run \"$(basename "$0")\"."
    exit 1
fi

trap 'echo "Ping exit (Ctrl-C)"; exit 1' 2

IP="$1"
INTERFACE="$2"

if [[ -z "$IP" ]]; then
    echo "\$IP must be passed as first positional argument" >&2
    exit 1;
fi

if [[ -z "$INTERFACE" ]]; then
    echo "\$INTERFACE must be passed as second positional argument" >&2
    exit 1
fi

ip_re='^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])\.?\b){2,4}$'

if ! [[ $IP =~ $ip_re ]]; then
    echo "Incorrect \$IP format" >&2
    exit 1
fi

inteface_array=$(ls /sys/class/net)
if [[ ! $inteface_array =~ $INTERFACE ]]; then
    echo "Interface $INTERFACE doesn't exists" >&2
    exit 1
fi

PREFIX=$(cut -s -d. -f1,2 <<< "$IP")

tmp="$(cut -s -d. -f3 <<< "$IP")"
SUBNET="${tmp:-${OCTET_RANGE[@]}}"

tmp="$(cut -s -d. -f4 <<< "$IP")"
HOST="${tmp:-${OCTET_RANGE[@]}}"

for SUBNET in $SUBNET; do
    for HOST in $HOST; do
        echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
        # В Arch и Manjaro arping-th - это Debian-like arping.
        # Либо менять на `arping -c 3 -I "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null`
        # но тогда выхлоп будет немного другим.
        arping-th -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
    done
done
