#!/bin/bash
./scripts/name-desktop.sh "$(cat iosevka-glyphs.nam | dmenu -b -p 'Enter name for desktop: ')"
