#!/usr/bin/env bash

# Menu options
shutdown="󰐥"
reboot="󰜉"
suspend="󰒲"
logout="󰍃"
lock="󰌾"

# Give options to rofi and save choice
chosen="$(echo -e "$shutdown\n$reboot\n$suspend\n$lock\n$logout" | rofi -dmenu -config "$HOME/.config/rofi/powermenu.rasi" )"

case $chosen in
    $lock)
        hyprlock;;
    $logout)
        niri msg action quit -s;;
    $suspend)
        systemctl suspend;;
    $reboot)
        systemctl reboot;;
	$shutdown)
        systemctl poweroff;;
esac
