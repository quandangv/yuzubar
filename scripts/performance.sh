#!/bin/bash
# Args: path retrieve_rate battery_name thermal_zone

path=$1
show_cpu() {
  [[ -n "$1" ]] && label=CPU || label=cpu
  echo %{+u}$label %{T2}${cpu[1]}%{-u T-}
}

show_memory() {
  [[ -n "$1" ]] && label=RAM || label=ram
  echo %{+u}$label %{T2}$memory%{-u T-}
}

show_temperature() {
  echo %{+u T2}$temperature%{T-}°C%{-u}
}

show_battery() {
  if $1; then label=bat; else label=BAT; fi
  echo %{+u}$label %{T2}$battery%{T- -u}
}

cpu[0]="0 0"
mode=0
mode_count=4
count=0
while :; do
  mapfile -t cpu < <(./scripts/cpu.sh ${cpu[0]})

  if [[ $(($count%2)) -eq 0 ]]; then
    memory=$(./scripts/memory.sh)
  fi

  temperature=$(./scripts/temp.sh $4)

  if [[ $(($count%10)) -eq 0 ]]; then
    battery=$(./scripts/battery.sh $3)
  fi

  status=1
  if (( $(echo "$battery < 20" | bc -l) )); then
    msg="$(show_battery true)"
  elif (( $(echo "$temperature > 70" | bc -l) )); then
    msg="$(show_temperature)"
  elif (( $(echo "$memory > 80" | bc -l) )); then
    msg="$(show_memory true)"
  elif (( $(echo "${cpu[1]} > 90" | bc -l) )); then
    msg="$(show_cpu true)"
  else
    status=0
    case $mode in
      0) msg="$(show_battery)"; ;;
      1) msg="$(show_cpu)"; ;;
      2) msg="$(show_temperature)"; ;;
      3) msg="$(show_memory)"; ;;
      *)
        mode=0
    esac
  fi
  echo "$status;%{A:save $path=$(((mode+1)%mode_count)): A3:save $path=$(((mode+mode_count-1)%mode_count)):}$msg%{A A3}"

  read -t $2 newmode
  if [ -n "$newmode" ]; then
    mode="$newmode"
  fi
  ((count++))
done

