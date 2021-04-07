#!/bin/bash
last_usage=$1
last_total=$2
IFS=' '
read -ra cpu <<< "$(grep 'cpu ' /proc/stat)"
usage=$((${cpu[1]} + ${cpu[3]}))
total=$(($usage + ${cpu[4]}))
echo $usage $total
echo $usage $last_usage $total $last_total | awk '{printf "%.1f\n", ($1 - $2) * 100 / ($3 - $4);}'
