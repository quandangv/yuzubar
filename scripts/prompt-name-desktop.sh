#!/bin/bash
./scripts/name-desktop.sh "$(cat font/iosevka-glyphs.nam | dmenu -b -p 'Enter name for desktop: ')"
