#!/bin/bash

read -r -p "Введите имя файла: " filename

case "$filename" in
*.jpg | *.png | *.gif)
	filetype="image"
    ;;
*.mp3 | *.wav)
    filetype="audio"
    ;;
*.txt | *.doc)
    filetype="text"
    ;;
*)
    filetype="unknown"
    ;;
esac

echo "$filetype"
exit 0

