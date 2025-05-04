#!/bin/bash

# Get the focused window title from Aerospace
FOCUSED_WINDOW=$(aerospace list-windows --workspace focused | head -n 1)
if [ -n "$FOCUSED_WINDOW" ]; then
  WINDOW_TITLE=$(echo "$FOCUSED_WINDOW" | awk -F'|' '{print $2}' | xargs)
  # Truncate long titles
  if [ ${#WINDOW_TITLE} -gt 40 ]; then
    WINDOW_TITLE="${WINDOW_TITLE:0:37}..."
  fi
else
  WINDOW_TITLE=""
fi

sketchybar --set $NAME label="$WINDOW_TITLE"
