#! /usr/bin/env bash

HOME_DIR=/home/vivek/
QTIL_DIR=$HOME_DIR/.config/qtile

# xrandr --output eDP-1 --scale 1.25x1.25
# xrandr --output DP-1 --scale 1.0x1.0

# main_screen="eDP-1"
# xtrn_screen=`xrandr | grep "connected" | grep '2560' | grep 'DP' | awk '{print $1}'`
# if [ "$xtrn_scrren" == "DP-1" ]; then
#   xrandr --output $main_screen --mode 1920x1200 --pos 0x0 --rotate normal --scale 1.45x1.45 \
#          --output $xtrn_screen --mode 2560x1440 --pos 2400x0 --rotate normal --scale 1.0x1.0
# fi 


# Lockscreen
betterlockscreen -u $HOME_DIR/.config/qtile/wallpapers --fx blur

# Dunst
$QTIL_DIR/scripts/qtile_dunst & disown

# Polybar
# $QTIL_DIR/scripts/qtile_polybar & disown

# Picom Compositor
picom & disown # Compositor

wal -R &

 # start polkit agent from GNOME
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown

# Start battery monitor
/home/vivek/.config/qtile/scripts/hardware/battery_warning.sh & disown
