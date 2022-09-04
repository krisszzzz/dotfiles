#!/bin/sh
modprobe -r rtw88_8821ce
modprobe rtw88_8821ce ant_sel=1


xrandr --setprovideroutputsource modesetting Nvidia-1 
xrandr --auto
#nitrogen --restore &

# Caps_Lock settings, and scrolling rate in vim (nvim)
xset r rate 300 50
setxkbmap -option 'caps:ctrl_modifier' && xcape -e 'Caps_Lock=Escape'
#exec --no-startup-id "setxkbmap -layout us,ru -option grp:alt_shift_toggle"

exec i3

#exec xmonad 
