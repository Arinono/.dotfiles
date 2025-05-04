#!/bin/bash

source "$CONFIG_DIR/icons.sh"

TIME=$(date '+%H:%M')
DATE=$(date '+%a %d %b')

sketchybar --set $NAME icon="$CLOCK" label="$TIME  $DATE"
