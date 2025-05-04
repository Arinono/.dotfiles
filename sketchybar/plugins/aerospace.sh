#!/bin/bash

# Aerospace workspace info
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
ALL_WORKSPACES=$(aerospace list-workspaces --all)

WORKSPACE_ICONS=""
for workspace in $ALL_WORKSPACES; do
  if [ "$workspace" = "$FOCUSED_WORKSPACE" ]; then
    WORKSPACE_ICONS+="[$workspace] "
  else
    WORKSPACE_ICONS+=" $workspace  "
  fi
done

sketchybar --set $NAME label="$WORKSPACE_ICONS"
