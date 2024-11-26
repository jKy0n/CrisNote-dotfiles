#!/usr/bin/env bash
#
#
#
/usr/libexec/polkit-gnome-authentication-agent-1 &

if  xrandr --query | grep -q "HDMI-1"; then
    sh /home/jkyon/.screenlayout/screenlayout-UltraWide.sh
fi

feh --bg-fill ~/Pictures/Wallpapers/catppuccin-wallpaper.png
picom --config /home/jkyon/.config/picom/picom.conf --daemon --backend glx &
