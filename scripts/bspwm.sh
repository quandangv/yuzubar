#!/bin/bash
focus_open=$1
focus_close=$2

while read raw; do
  focused=1
  desktops=()
  # Separate raw output into info of individual desktops
  IFS=':' read -r -a desktop_info <<< $raw
  for info in "${desktop_info[@]}"; do
  #for index in {1..10}; do
    dsk_status="${info:0:1}"
    dsk_name="${info:1}"
    id=$((${#desktops[@]}+1))
    # Display each desktop differently based on its status
    case $dsk_status in
      # unfocused empty
      "f") dsk_display='%{O8}·%{O8}'; ;;
      # unfocused occupied
      "o") dsk_display="%{O8}${dsk_name,,}%{O8}"; ;;
      # focused
      "O" | "F" | "U") focused=$id; ;&
      # urgent
      "u") dsk_display="$focus_open%{O8}${dsk_name^^}%{O8}$focus_close"; ;;
      *) continue;
    esac

    # Clicking will switch to that desktop
    desktops+=("%{A:bspc desktop ^$id -f: A3:bspc node -d ^$id:}$dsk_display%{A A3}")
  done

  # put the focused desktop at the center
  size=${#desktops[@]}
  desktop_list=
  for index in "${!desktops[@]}"; do
    desktop_list+=${desktops[$((($index+$focused + 5)%$size))]}
  done

  # Scroll through desktops
  scroll_cmd="A4:bspc desktop -f prev.local: A5:bspc desktop -f next.local:))"
  echo "%{+u $scroll_cmd -f:}$desktop_list%{-u A4 A5}"
done < <(bspc subscribe)

