#!/bin/bash
char_count=$1
while :; do
  raw=$(amixer sget Master)
  percent=$(sed -n 's/.*\[\([0-9]*%\)\].*/\1/p' <<< $raw)

  if [[ "$raw" == *"[off]"* ]]; then
    echo "%{A:amixer -q sset Master toggle: +u}vol x%{A -u}"
  else
    filled_count=$(echo $percent $char_count | awk '{ printf "%i", $1 / 100 * $2; }' )
    empty_count=$(bc <<< "$char_count - $filled_count")
    filled=$(printf '%*s' $filled_count "")
    empty=$(printf '%*s' $empty_count "")
    echo "%{+u A4:amixer -q sset Master 5%+: A5:amixer -q sset Master 5%-: A:amixer -q sset Master toggle:}vol%{T2 A A:amixer -q sset Master 9%-:} ${filled// /·}%{A A:amixer -q sset Master 9%+:}$2${empty// /·} %{A A4 A5 -u T-}"
  fi

  read
done < <(stdbuf -oL alsactl monitor)
