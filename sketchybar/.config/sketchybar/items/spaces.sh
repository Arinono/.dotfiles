#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change
RED=0xffed8796
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item "space.$sid" left \
        --subscribe "space.$sid" aerospace_workspace_change \
        --set "space.$sid" \
        icon="$sid"\
                              icon.padding_left=8                          \
                              icon.padding_right=8                         \
                              icon.highlight_color=$RED                     \
                              background.color=0x44ffffff \
                              background.corner_radius=5 \
                              background.height=20 \
                              background.drawing=off                         \
                              label.font="sketchybar-app-font:Regular:16.0" \
                              label.background.height=20                    \
                              label.background.drawing=on                   \
                              label.background.color=0xff494d64             \
                              label.background.corner_radius=5              \
                              label.drawing=off                             \
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospacer.sh $sid"
done

# sketchybar   --add item       separator left                          \
#              --set separator  icon=                                  \
#                               icon.font="$ICON_FONT:Regular:16.0" \
#                               background.padding_left=15              \
#                               background.padding_right=15             \
#                               label.drawing=off                       \
#                               associated_display=active               \
#                               icon.color=$WHITE
