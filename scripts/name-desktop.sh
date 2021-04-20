#!/bin/bash
newname=$1
desktop=$2

if [ "${newname:0:2}" = "0x" ]; then
  set -- $newname
  echo -e found glyph: $2 "\u${1:2}"
  newname=$(echo -e "\u${1:2}")
fi

bspc desktop $desktop -n "$newname"
