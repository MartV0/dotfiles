#!/usr/bin/env bash

# wait for internet to be available before mounting

while ! ping -c 1 -W 1 example.com; 
do 
    sleep 2 
done

rclone mount --daemon --vfs-cache-mode full google_drive:/ /home/martijn/Documents/drive
