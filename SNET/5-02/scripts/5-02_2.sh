#!/bin/bash

while true; do
    echo -n "$(date +"[%T]") - "
    cat /proc/loadavg
    sleep 5
done
