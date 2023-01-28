#!/usr/bin/env bash

ROOTUSER_NAME=root

username=$(id -nu)
if [ "$username" != "$ROOTUSER_NAME" ]; then
    echo "Must be root to run \"$(basename "$0")\"."
    exit 1
fi

trap 'echo "Ping exit (Ctrl-C)"; exit 1' 2

OCTET_RANGE=({0..255})
IP="$1"
# TODO: ip regex validation

tmp="$(cut -s -d. -f1,2 <<< "$IP")"
PREFIX="${tmp:-NOT_SET}"

tmp="$(cut -s -d. -f3 <<< "$IP")"
SUBNET="${tmp:-${OCTET_RANGE[@]}}"

tmp="$(cut -s -d. -f4 <<< "$IP")"
HOST="${tmp:-${OCTET_RANGE[@]}}"

INTERFACE="$2"

[[ "$PREFIX" = "NOT_SET" ]] && {
    echo "\$PREFIX must be passed as first positional argument"
    exit 1;
}

if [[ -z "$INTERFACE" ]]; then
    echo "\$INTERFACE must be passed as second positional argument"
    exit 1
fi

for SUBNET in $SUBNET; do
    for HOST in $HOST; do
        echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
        arping-th -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
    done
done
