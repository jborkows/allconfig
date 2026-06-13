#!/bin/bash

# Find card that has hdmi-stereo profile available
# Search for cards with Name: alsa_card.pci (internal audio)
CARD=$(pactl list cards | grep "Name: alsa_card.pci" | awk '{print $2}' | head -1)

if [ -z "$CARD" ]; then
    echo "No internal audio card found"
    exit 1
fi

# Build sink name from card name
SINK=${CARD/alsa_card/alsa_output}.hdmi-stereo

pactl set-card-profile "$CARD" output:hdmi-stereo
pactl set-default-sink "$SINK"
