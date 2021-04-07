#!/bin/bash
char_count=$1
while :; do
  percent=$(iwconfig wlan0 | sed -n 's/.*Quality=\([0-9/]*\).*/\1/p' | bc -l)

  if [[ -z "$percent" ]]; then
    echo "%{A:termite --hold -e \"iwctl\": +u}wifi x%{A -u}"
  else
    filled_count=$(echo $percent $char_count | awk '{ printf "%i", $1 * $2; }' )
    empty_count=$(bc <<< "$char_count - $filled_count")
    filled=$(printf '%*s' $filled_count "")
    empty=$(printf '%*s' $empty_count "")
    echo "%{A:termite --hold -e \"iwctl\": +u}wifi%{T2} ${filled// /·}$2${empty// /·}%{T- A -u}"
  fi

  sleep 2
done

