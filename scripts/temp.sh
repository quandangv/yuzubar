#!/bin/bash
cat /sys/class/thermal/thermal_zone$1/temp | awk '{ printf $1/1000; }'
