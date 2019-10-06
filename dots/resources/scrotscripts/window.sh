#!/usr/bin/bash
filename=~/Pictures/Screenshots/$(date +%s).png
escrotum -s $filename
xclip -i $filename -sel clipboard -t image/jpeg
twmnc --title scrot --content "capture taken"
