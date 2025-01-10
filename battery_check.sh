#!/bin/sh

# Script to print the charge threshold values and the current capacity.

info() {
  bat=$1
  name=$(basename "$1")
  status=$(cat "$bat/status")
  
  # Check for charge or energy files
  if [ -f "$bat/charge_now" ] && [ -f "$bat/charge_full" ]; then
    charge_now=$(cat "$bat/charge_now")
    charge_full=$(cat "$bat/charge_full")
    capacity=$(awk "BEGIN {printf \"%.0f\", ($charge_now / $charge_full) * 100}")
  else
    capacity="N/A"
  fi

  # Check for charge threshold files
  if [ -f "$bat/charge_start_threshold" ] && [ -f "$bat/charge_stop_threshold" ]; then
    start=$(cat "$bat/charge_start_threshold")
    stop=$(cat "$bat/charge_stop_threshold")
  else
    start="N/A"
    stop="N/A"
  fi

  printf "%s: %-12.12s, capacity: %-10s%%, start: %-10s, stop: %s\n" \
        "$name" "$status" "$capacity" "$start" "$stop"
}

for bat in /sys/class/power_supply/BAT*; do
  if [ -d "$bat" ]; then
    info "$bat"
  fi
done

