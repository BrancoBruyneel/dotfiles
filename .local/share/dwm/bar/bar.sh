#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors!
. $HOME/.local/share/dwm/bar/themes/onedark

cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	printf ""
	printf " $cpu_val"
}

gpu() {
  gpu_val=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader)

  printf ""
  printf " $gpu_val"
}

pkg_updates() {
	# updates=$(doas xbps-install -un | wc -l) # void
    updates=$(checkupdates | wc -l)   # arch , needs pacman contrib
	# updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

	if [ -z "$updates" ]; then
		printf " Fully Updated"
	else
		printf " $updates"" updates"
	fi
}

battery() {
	get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
	printf "^c$blue^   $get_capacity"
}

brightness() {
	printf "^c$red^   "
	printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
	printf " "
	printf "$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf " "
	printf "$(date '+%I:%M %p')"
}

while true; do

	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
	interval=$((interval + 1))

    sleep 1 && xsetroot -name "$(clock);$updates  $(cpu)  $(mem)  "
done
