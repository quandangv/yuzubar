#!/bin/bash
focus_open=$1
focus_close=$2
while read raw; do
  focused=1
  # Separate raw output into info of individual desktops
  IFS=':' read -r -a desktop_info <<< $raw
  for index in {1..10}; do
    dsk_status="${desktop_info[$index]:0:1}"
    dsk_name="${desktop_info[$index]:1}"
    # Display each desktop differently based on its status
    case $dsk_status in
      # unfocused empty
      "f") desktop_info[$index]='%{O8}·%{O8}'; ;;
      # unfocused occupied
      "o") desktop_info[$index]="%{O8}${dsk_name,,}%{O8}"; ;;
      # focused
      "O" | "F" | "U") focused=$index; ;&
      # urgent
      "u") desktop_info[$index]="$focus_open%{O8}${dsk_name^^}%{O8}$focus_close"; ;;
    esac

    # Clicking will switch to that desktop
    desktop_info[$index]="%{A:bspc desktop ^$index -f: A3:bspc node -d ^$index:}${desktop_info[$index]}%{A A3}"
  done

  # put the focused desktop at the center
  for index in {1..10}; do
    ordered[$((($index-$focused + 15)%10))]=${desktop_info[$index]}
  done

  # Scroll through desktops
  scroll_cmd="A4:bspc desktop ^$(((focused)%10 + 1)) -f: A5:bspc desktop ^$(((focused + 8)%10 + 1))"
  echo "%{+u $scroll_cmd -f:}${ordered[0]}${ordered[1]}${ordered[2]}${ordered[3]}${ordered[4]}${ordered[5]}${ordered[6]}${ordered[7]}${ordered[8]}${ordered[9]}%{-u A4 A5}"
done < <(bspc subscribe)

