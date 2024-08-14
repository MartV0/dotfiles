#!/usr/bin/env bash

rclone mount --daemon --vfs-cache-mode full google_drive:/ /home/martijn/Documents/drive
