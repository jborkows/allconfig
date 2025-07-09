#!/usr/bin/env bash
while true; do
  swww img "$(find ~/.config/hypr/backgrounds/ -type f | shuf -n 1)"   --transition-type wipe   --transition-pos 0.5,0.5   --transition-fps 60   --transition-duration 1.5   --transition-step 100
  sleep 10m
done

