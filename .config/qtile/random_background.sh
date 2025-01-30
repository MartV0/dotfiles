#!/usr/bin/env bash 

cd ~/Pictures/achtergrondjes
ls | grep -E ".+\\.(jpe?g)|.+\\.(png)" | sort -R | head -1 | xargs xwallpaper --output all --zoom
