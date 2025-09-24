#!/usr/bin/env bash

cd ~/Pictures/achtergrondjes
options="$(ls | grep -E ".+\\.(jpe?g)|.+\\.(png)")"
lines="$(echo -e "$options" | wc -l)"
chosen="$(echo -e "$options" | rofi -lines "$lines" -dmenu -p "background")"
echo "$chosen"
swww img -t grow --transition-step 10 "$chosen"
