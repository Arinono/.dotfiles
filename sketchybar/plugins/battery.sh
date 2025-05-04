#!/bin/bash

source "$CONFIG_DIR/icons.sh"

BATTERY_INFO=$(pmset -g batt)
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

if [[ $CHARGING != "" ]]; then
  ICON=$BATTERY_CHARGING
else
  if [ "$PERCENTAGE" -ge 75 ]; then
    ICON=$BATTERY_100
  elif [ "$PERCENTAGE" -ge 50 ]; then
    ICON=$BATTERY_75
  elif [ "$PERCENTAGE" -ge 25 ]; then
    ICON=$BATTERY_50
  elif [ "$PERCENTAGE" -ge 10 ]; then
    ICON=$BATTERY_25
  else
    ICON=$BATTERY_0
  fi
fi

sketchybar --set $NAME icon="$ICON" label="$PERCENTAGE%"
