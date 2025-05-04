#!/bin/bash

source "$CONFIG_DIR/icons.sh"

CPU_USAGE=$(top -l 2 | grep -E "^CPU" | tail -1 | awk '{print $3}' | cut -d% -f1)

sketchybar --set $NAME icon="$CPU" label="$CPU_USAGE%"
