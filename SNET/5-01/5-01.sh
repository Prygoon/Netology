#!/bin/bash

# Флаг -r отключает интерпретацию ввода, -p - строка приглашения
read -r -p "Введите путь для новой директории: " filepath

if [[ ! -d $filepath ]]; then
	# Замеяем в filepath знак ~ на переменную $HOME
    mkdir "${filepath/#~/$HOME}" && echo "Директория $filepath создана"
else
    echo "Такая директория уже существует"
fi;
