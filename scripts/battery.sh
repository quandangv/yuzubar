#!/bin/bash
[[ -z "$1" ]] && exit 1
cat /sys/class/power_supply/$1/charge_now /sys/class/power_supply/$1/charge_full | tr "\n" " " | awk '{printf "%.1f", $1 / $2 * 100.0; }'
exit ${PIPESTATUS[0]}
