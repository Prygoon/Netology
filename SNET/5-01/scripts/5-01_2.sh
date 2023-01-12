#!/bin/bash

read -r -p "Введите два числа: " first_num second_num

# Validate input
re='^[0-9]+$'
if ! [[ $first_num =~ $re && $second_num =~ $re ]]; then
    echo "Ошибка: вы ввели не число" >&2
    exit 1
fi

if [[ $first_num -eq $second_num ]]; then
    result=$((first_num * second_num))
elif [[ $first_num -lt $second_num ]]; then
    result=$((second_num - first_num))
else
    result=$((first_num - second_num))
fi

echo "$result"
