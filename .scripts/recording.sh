#!/bin/bash

DURATION_MINUTES=${1:-1}
TOTAL_SECONDS=$((DURATION_MINUTES * 60))

cleanup() {
    echo -e "\nStopping recording..."
    kill $VIDEO_PID $AUDIO_PID 2>/dev/null
    wait $VIDEO_PID $AUDIO_PID 2>/dev/null
    
    echo "Combining files..."
    result_file="final_output$(date +%Y%m%d_%H%M%S).mp4"
    ffmpeg -i screen.mp4 -i audio.wav -c:v copy -c:a aac ${result_file} -y
    rm screen.mp4 audio.wav
    echo "Done!"
    exit 0
}

trap cleanup SIGINT

hyprctl dispatch workspace 2 > /dev/null 2>&1
echo "Starting recording for $DURATION_MINUTES minutes..."

wf-recorder -o HDMI-A-1 -f screen.mp4 &
VIDEO_PID=$!

parecord --device=$(pactl get-default-sink).monitor --file-format=wav audio.wav &
AUDIO_PID=$!

# Progress counter
for ((i=1; i<=TOTAL_SECONDS; i++)); do
    REMAINING=$((TOTAL_SECONDS - i))
    MINS=$((REMAINING / 60))
    SECS=$((REMAINING % 60))
    printf "\rRecording... %02d:%02d remaining (Ctrl+C to stop early)" $MINS $SECS
    sleep 1
done

echo -e "\nTime's up! Stopping recording..."
cleanup
