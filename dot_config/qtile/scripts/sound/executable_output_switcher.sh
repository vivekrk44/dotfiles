#!/bin/bash

# Get list of sinks (output devices)
sinks=$(pactl list short sinks | cut -f1,2)
active_sink=$(pactl get-default-sink)

# Function to get the next sink
get_next_sink() {
    local current=$1
    local found=0
    local first_sink=""
    local next_sink=""

    while IFS= read -r line; do
        sink_id=$(echo "$line" | cut -f1)
        sink_name=$(echo "$line" | cut -f2)
        
        # Store first sink for wrapping
        if [ -z "$first_sink" ]; then
            first_sink=$sink_name
        fi
        
        # If we found the current sink in the previous iteration, this is the next one
        if [ $found -eq 1 ]; then
            next_sink=$sink_name
            break
        fi
        
        # Check if this is the current sink
        if [ "$sink_name" = "$current" ]; then
            found=1
        fi
    done <<< "$sinks"
    
    # If we didn't find a next sink, wrap around to the first one
    if [ -z "$next_sink" ]; then
        next_sink=$first_sink
    fi
    
    echo "$next_sink"
}

# Get the next sink in the list
next_sink=$(get_next_sink "$active_sink")

# Set the next sink as default
pactl set-default-sink "$next_sink"

# Move all current audio streams to the new sink
pactl list short sink-inputs | cut -f1 | while read stream; do
    pactl move-sink-input "$stream" "$next_sink"
done

# Get friendly name for notification
friendly_name=$(pactl list sinks | grep -A1 "Name: $next_sink" | grep "Description" | sed 's/.*Description: \(.*\)/\1/')

# Send notification
dunstify -a "Audio Switcher" -u normal -i audio-card "Audio Output" "Switched to $friendly_name" -r 9000
