coredump="A:termite --hold -e \"sudo bash -c 'echo core.%e.%p > /proc/sys/kernel/core_pattern'\":}core dump%{A"
name_desktop="A:./scripts/name-all-desktops.sh:}Name Desktops%{A"
echo O20 +u $name_desktop -u
