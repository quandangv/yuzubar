close="save $1=close"
hibernate="A:systemctl hibernate:}Hibernate%{A"
open="A:save $1=open: T2}···%{T- A"
hide="A:save mode=true:}Hide%{A"
suspend="A:systemctl suspend-then-hibernate:}Suspend%{A"
change_theme="A:./scripts/change-theme.sh:}Change Theme%{A"
shift

if [ "$1" = "open" ]; then
  echo open
  echo "%{+u A:$close:}X%{A -u O20 +u $hibernate -u O20 +u $suspend -u O20 +u $change_theme -u $(./scripts/extra-options.sh) -u}"
else
  shift
  echo close
  echo "%{+u $open -u O20}$@"
fi

