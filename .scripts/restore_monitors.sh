#!/usr/bin/env bash
## see .config/hypr/hyprland.conf for monitors names
for i in {1..6}; do
         hyprctl dispatch moveworkspacetomonitor "$i HDMI-A-1"
done

