#!/usr/bin/env bash

# Start background services
gnome-keyring-daemon --start --components=secrets &
hyprpaper &
nm-applet --indicator &
ags &
hyprpanel &
dunst &