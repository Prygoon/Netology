#!/bin/bash

read -r -p "Введите имя файла: " filename

case "$filename" in
*.jpg | *.png | *.gif)
    echo "image"
    ;;
*.mp3 | *.wav)
    echo "audio"
    ;;
*.txt | *.doc)
    echo "text"
    ;;
*)
    echo "unknown"
    ;;
esac
