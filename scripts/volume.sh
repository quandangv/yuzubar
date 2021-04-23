#!/bin/bash

char_count=$1
separator=$2
control=$3
label=$4

while :; do
  raw=$(amixer sget $control)
  percent=$(sed -n 's/.*\[\([0-9]*%\)\].*/\1/p' <<< $raw)

  if [[ "$raw" == *"[off]"* ]]; then
    echo "%{A:amixer -q sset $control toggle: +u}$label x%{A -u}"
  else
    filled_count=$(echo $percent | awk "{ sum += \$1 / 100 * $char_count; } END { printf \"%i\", sum/NR; }" )
    empty_count=$(bc <<< "$char_count - $filled_count")
    filled=$(printf '%*s' $filled_count "")
    empty=$(printf '%*s' $empty_count "")
    echo "%{+u A4:amixer -q sset $control 5%+: A5:amixer -q sset $control 5%-: A:amixer -q sset $control toggle:}$label%{T2 A A:amixer -q sset $control 9%-:} ${filled// /·}%{A A:amixer -q sset $control 9%+:}$separator${empty// /·} %{A A4 A5 -u T-}"
  fi

  read
done < <(stdbuf -oL alsactl monitor)
