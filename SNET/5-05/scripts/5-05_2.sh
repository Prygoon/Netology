#!/usr/bin/env bash

ROOTUSER_NAME=root

username=$(id -nu)
if [ "$username" != "$ROOTUSER_NAME" ]; then
    echo "Must be root to run \"$(basename "$0")\"."
    exit 1
fi

trap 'echo "Ping exit (Ctrl-C)"; exit 1' 2

INTERFACE="$1"

if [[ -z "$INTERFACE" ]]; then
    echo "\$INTERFACE must be passed as positional argument" >&2
    exit 1
fi

inteface_array=$(ls /sys/class/net)
if [[ ! $inteface_array =~ $INTERFACE ]]; then
    echo "Interface $INTERFACE doesn't exists" >&2
    exit 1
fi

IP_WITH_MASK="$(ip -4 addr show "$INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d{1,2}')"

# Тут хотел писать свой велосипед, но потом нашёл ipcalc
HOST_MIN="$(ipcalc -b "$IP_WITH_MASK" | awk '/HostMin/ {print $2}')"
HOST_MAX="$(ipcalc -b "$IP_WITH_MASK" | awk '/HostMax/ {print $2}')"

min_octet_1="$(awk -F. '{ print $1 }' <<< "$HOST_MIN")"
min_octet_2="$(awk -F. '{ print $2 }' <<< "$HOST_MIN")"
min_octet_3="$(awk -F. '{ print $3 }' <<< "$HOST_MIN")"
min_octet_4="$(awk -F. '{ print $4 }' <<< "$HOST_MIN")"

max_octet_1="$(awk -F. '{ print $1 }' <<< "$HOST_MAX")"
max_octet_2="$(awk -F. '{ print $2 }' <<< "$HOST_MAX")"
max_octet_3="$(awk -F. '{ print $3 }' <<< "$HOST_MAX")"
max_octet_4="$(awk -F. '{ print $4 }' <<< "$HOST_MAX")"

# 4 вложенных цикла выглядят ужасно, но, к сожалению, пока не знаю как на баше сделать изящнее.
# Если вдруг кто-то из проверяющих экспертов обратит внимание на этот комментарий,
# то очень хочется узнать как сделать лучше.
for octet_1 in $(seq "$min_octet_1" "$max_octet_1"); do
    for octet_2 in $(seq "$min_octet_2" "$max_octet_2"); do
        for octet_3 in $(seq "$min_octet_3" "$max_octet_3"); do
            for octet_4 in $(seq "$min_octet_4" "$max_octet_4"); do
                echo "[*] IP : ${octet_1}.${octet_2}.${octet_3}.${octet_4}"

                # В Arch и Manjaro arping-th - это Debian-like arping.
                # Либо менять на `arping -c 3 -I "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null`
                # но тогда выхлоп будет немного другим.
                arping-th -c 3 -i "$INTERFACE" "${octet_1}.${octet_2}.${octet_3}.${octet_4}" 2> /dev/null
            done
        done
    done
done
