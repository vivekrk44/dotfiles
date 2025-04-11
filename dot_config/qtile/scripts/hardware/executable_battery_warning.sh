#! /usr/bin/env bash
#
# This script is called by a cron job to check the battery level of the laptop and send a warning via dunst 
# if the battery level is less than 20% and the laptop is not plugged in. It will send a critical warning if
# the battery level is less than 10% and the laptop is not plugged in. It will persist the warning until the
# laptop is plugged in.
#

BATTERY=/sys/class/power_supply/BAT0

while true; do
# Get the battery level
  REM=$(cat $BATTERY/charge_now)
  FULL=$(cat $BATTERY/charge_full)
  LEVEL=`echo $(( $REM * 100 / $FULL ))`
  
  if [ $LEVEL -lt 20 ]; then
    if [ $(cat $BATTERY/status) = "Discharging" ]; then
      if [ $LEVEL -lt 10 ]; then
          dunstify -u critical -r 10000 "Battery level is critical: $LEVEL%"
      else
          dunstify -u normal -r 1000 "Battery level is low: $LEVEL%"
      fi
    fi
  fi
  sleep 60
done
