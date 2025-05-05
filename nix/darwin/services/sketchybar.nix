{...}: {
  services.sketchybar = {
    enable = false;

    config = ''
      # Sketchybar configuration with Aerospace integration
      export CONFIG_DIR=$XDG_CONFIG_HOME/sketchybar
      export PLUGIN_DIR=$CONFIG_DIR/plugins
      source "$CONFIG_DIR/colors.sh"
      source "$CONFIG_DIR/icons.sh"

      # Basic bar appearance
      sketchybar --bar position=top \
                       height=32 \
                       blur_radius=30 \
                       color=$BAR_COLOR

      # Default settings
      sketchybar --default updates=when_shown \
                           icon.font="SF Pro:Semibold:14.0" \
                           icon.color=$ICON_COLOR \
                           label.font="SF Pro:Semibold:14.0" \
                           label.color=$LABEL_COLOR \
                           padding_left=5 \
                           padding_right=5 \
                           label.padding_left=4 \
                           label.padding_right=4 \
                           icon.padding_left=4 \
                           icon.padding_right=4

      # Aerospace workspace display
      sketchybar --add item aerospace_workspace left \
                 --set aerospace_workspace script="$PLUGIN_DIR/aerospace.sh" \
                       label.font="SF Pro:Bold:14.0" \
                       click_script="aerospace list-windows --workspace focused | head -n 1 | cut -f2 -d'|' | xargs aerospace focus --window-id" \
                       updates=on \
                       background.padding_left=8 \
                       background.padding_right=8

      # Window title display
      sketchybar --add item window_title left \
                 --set window_title script="$PLUGIN_DIR/window_title.sh" \
                       updates=on

      # Right side items
      sketchybar --add item clock right \
                 --set clock update_freq=10 \
                       icon=$CLOCK \
                       script="$PLUGIN_DIR/clock.sh"

      sketchybar --add item battery right \
                 --set battery update_freq=120 \
                       script="$PLUGIN_DIR/battery.sh"

      # CPU item
      sketchybar --add item cpu right \
                 --set cpu update_freq=5 \
                       script="$PLUGIN_DIR/cpu.sh"

      # Volume item
      sketchybar --add item volume right \
                 --set volume script="$PLUGIN_DIR/volume.sh"

      # Update all items
      sketchybar --update
    '';
  };
}
