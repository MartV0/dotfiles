#!/usr/bin/env bash

# options to be displayed
option0="monitors setup"
option1="bluetooth"
option2="printer"
option3="audio"
option4="appearance"
option5="random background"
option6="choose background"

# options passed into variable
options="$option0\n$option1\n$option2\n$option3\n$option4\n$option5\n$option6"

chosen="$(echo -e "$options" | rofi -lines 6 -dmenu -p "power")"
case $chosen in
    $option0)
        wdisplays;;
    $option1)
        blueman-manager;;
    $option2)
        system-config-printer;;
    $option3)
        pavucontrol;;
	$option4)
        lxappearance;;
    $option5)
        cd ~/Pictures/achtergrondjes
        ls | grep -E ".+\\.(jpe?g)|.+\\.(png)" | sort -R | head -1 | xargs swww img -t grow;;
    $option6)
        ~/.config/rofi/scripts/choose_background.sh
esac
