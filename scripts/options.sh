close="save $1=close"
hibernate="A:systemctl hibernate:}Hibernate%{A"
open="A:save $1=open: T2}···%{T- A"
hide="A:save mode=true:}Hide%{A"
suspend="A:systemctl suspend-then-hibernate:}Suspend%{A"
shift

if [ "$1" = "open" ]; then
  echo open
  echo "%{+u A:$close: -u}X%{A O20 +u $hibernate -u O20 +u $suspend -u $(./scripts/extra-options.sh) -u}"
else
  shift
  echo close
  echo "%{+u $open -u O20}$@"
fi

