#!/bin/bash
[[ -z "$1" ]] && exit 1
cat /sys/class/thermal/$1/temp | awk '{ printf $1/1000; }'
