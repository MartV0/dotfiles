#!/usr/bin/env bash 

# nitrogen --restore & # https://unsplash.com/wallpapers/colors/dark
ls ~/Pictures/achtergrondjes | grep -E ".+\\.(jpe?g)|.+\\.(png)" | sort -R | head -1 | sed "s\^\\$HOME/Pictures/achtergrondjes/\\"| xargs xwallpaper --output all --zoom
picom &
nm-applet &
flameshot &
/usr/bin/emacs --daemon &
