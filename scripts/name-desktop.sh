#!/bin/bash
namefile=$1
newname=$2
desktop=$3

if glyph=$(grep " ${newname,,}$" "$namefile"); then
  echo -e found glyph: $glyph "\u${glyph:2:4}"
  newname=$(echo -e "\u${glyph:2:4}")
fi

bspc desktop $desktop -n "$newname"
