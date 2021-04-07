#!/bin/bash
free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}'
