#!/bin/bash

# Get current window size
current=$(hyprctl activewindow -j | jq -r '.size | "\(.[0]) \(.[1])"')
width=$(echo $current | awk '{print $1}')
height=$(echo $current | awk '{print $2}')

# Calculate 50% increase
new_width=$((width * 3 / 2))
new_height=$((height * 3 / 2))

# Resize and recenter
hyprctl dispatch resizeactive exact ${new_width} ${new_height}
hyprctl dispatch centerwindow
