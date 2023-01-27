#!/bin/bash

function avgfile() {
    path=$1
    file_count=0
    total_size=0

    if [[ ! -d $path ]]; then
        echo "Directory $path doesn't exists" >&2
        exit 1
    fi

    for file in "$path"/*; do
        if [[ -f $file ]]; then
            (( total_size += $(stat -c %s "$file") ))
            (( file_count++ ))
        fi
    done

    if [[ $file_count -eq 0 ]]; then
        echo "There is no files in $path"
    else
        echo "Average file size in $path is $(( total_size / file_count )) bytes"
    fi
}

avgfile "$1"
exit 0
