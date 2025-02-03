#!/usr/bin/env bash 

# nitrogen --restore & # https://unsplash.com/wallpapers/colors/dark
~/.config/qtile/random_background.sh
picom &
nm-applet &
flameshot &
/usr/bin/emacs --daemon &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
autorandr --change
