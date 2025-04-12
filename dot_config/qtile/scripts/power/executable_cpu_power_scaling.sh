#!/bin/bash

# Define the three desired max frequency profiles (in kHz)
DESIRED_MAX_FREQ=5200000    # 5200MHz
DESIRED_MED_FREQ=3500000    # 3500MHz
DESIRED_LOW_FREQ=2000000    # 2000MHz

# Set home path
HOME="/home/vivek"
# Path to store current profile state
STATE_FILE="$HOME/.config/qtile/cpu_profile"

# CPU info paths
CPU0_DIR="/sys/devices/system/cpu/cpu0/cpufreq"
ALLOW_MIN_FREQ="$CPU0_DIR/cpuinfo_min_freq"
ALLOW_MAX_FREQ="$CPU0_DIR/cpuinfo_max_freq"

# Get actual supported frequencies
if [ ! -e "$ALLOW_MIN_FREQ" ]; then
    dunstify -a "CPU Frequency" -u critical -i "dialog-error" "Error" "Cannot find minimum CPU frequency information" -r 9001
    exit 1
fi

if [ ! -e "$ALLOW_MAX_FREQ" ]; then
    dunstify -a "CPU Frequency" -u critical -i "dialog-error" "Error" "Cannot find maximum CPU frequency information" -r 9001
    exit 2
fi

# Read the system's supported frequencies
SYSTEM_MIN_FREQ=$(cat "$ALLOW_MIN_FREQ")
SYSTEM_MAX_FREQ=$(cat "$ALLOW_MAX_FREQ")

# Function to clamp frequency within system limits
clamp_frequency() {
    local freq=$1
    if [ "$freq" -lt "$SYSTEM_MIN_FREQ" ]; then
        echo "$SYSTEM_MIN_FREQ"
    elif [ "$freq" -gt "$SYSTEM_MAX_FREQ" ]; then
        echo "$SYSTEM_MAX_FREQ"
    else
        echo "$freq"
    fi
}

# Clamp desired frequencies to system limits
MAX_FREQ=$(clamp_frequency $DESIRED_MAX_FREQ)
MED_FREQ=$(clamp_frequency $DESIRED_MED_FREQ)
LOW_FREQ=$(clamp_frequency $DESIRED_LOW_FREQ)

# Ensure the state file exists
if [ ! -f "$STATE_FILE" ]; then
    echo "low" > "$STATE_FILE"
fi

# Read current profile
CURRENT_PROFILE=$(cat "$STATE_FILE")

# Determine next profile
case "$CURRENT_PROFILE" in
    "low")
        NEXT_PROFILE="medium"
        TARGET_FREQ=$MED_FREQ
        ;;
    "medium")
        NEXT_PROFILE="max"
        TARGET_FREQ=$MAX_FREQ
        ;;
    *)
        NEXT_PROFILE="low"
        TARGET_FREQ=$LOW_FREQ
        ;;
esac

# Update state file
echo "$NEXT_PROFILE" > "$STATE_FILE"

# Get CPU cores
CPU_CORES=$(nproc)
LAST_CORE=$((CPU_CORES - 1))

# Base paths for CPU frequency settings
ALL_PREFIX="/sys/devices/system/cpu/cpu"
MIN_SUFFIX="/cpufreq/scaling_min_freq"
MAX_SUFFIX="/cpufreq/scaling_max_freq"

# Set frequencies for all CPU cores
for i in $(seq 0 $LAST_CORE); do
    # Always set min to system minimum
    echo "$SYSTEM_MIN_FREQ" > "${ALL_PREFIX}${i}${MIN_SUFFIX}"
    
    # Set max to the target frequency
    echo "$TARGET_FREQ" > "${ALL_PREFIX}${i}${MAX_SUFFIX}"
done

# Determine notification properties based on profile
if [ "$NEXT_PROFILE" = "max" ]; then
    ICON="cpu"
    URGENCY="low"
elif [ "$NEXT_PROFILE" = "medium" ]; then
    ICON="cpu"
    URGENCY="low"
else
    ICON="cpu"
    URGENCY="low"
fi

# Convert to MHz for display
DISPLAY_FREQ=$((TARGET_FREQ / 1000))
DESIRED_FREQ=$((DESIRED_${NEXT_PROFILE^^}_FREQ / 1000))

# Display additional info if we had to clamp the frequency
if [ "$DISPLAY_FREQ" -ne "$DESIRED_FREQ" ]; then
    CLAMP_INFO=" (adjusted from ${DESIRED_FREQ}MHz)"
else
    CLAMP_INFO=""
fi

# Send notification
dunstify -a "CPU Frequency" -u $URGENCY -i $ICON "CPU Profile: $NEXT_PROFILE" "Max frequency set to $DISPLAY_FREQ MHz$CLAMP_INFO" -r 9001
