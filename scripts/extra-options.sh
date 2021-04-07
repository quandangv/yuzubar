coredump="A:termite --hold -e \"sudo bash -c 'echo core.%e.%p > /proc/sys/kernel/core_pattern'\":}core dump%{A"
name_desktop="A:bspc desktop ^1 -n code; bspc desktop ^10 -n build; bspc desktop ^2 -n bar; bspc desktop ^3 -n web; bspc desktop ^4 -n pw:}Name Desktops%{A"
#echo O20 $name_desktop
