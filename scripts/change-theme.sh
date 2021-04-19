#!/bin/bash
theme=`ls ~/.config/theme-changer/schemes | dmenu -b`
~/.config/theme-changer/changer.sh ~/.config/theme-changer/schemes/$theme
