#!/bin/bash
cat /sys/class/thermal/$1/temp | awk '{ printf $1/1000; }'
