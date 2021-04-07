#!/bin/bash
path=$1
shift
mode=$1
mode_count=3
if [[ -z "$mode" ]]; then
  mode=0
fi
shift
case "$mode" in
  0) text="the time is %{T2}$(date +%H:%M)"; ;;
  1) text="the date is %{T2}$(date +%d-%m-%y)"; ;;
  2) text="$@"; ;;
esac

echo "$mode"
echo "%{A:save $path=$(((mode+1)%mode_count)): +u}$text%{T- A -u}"
