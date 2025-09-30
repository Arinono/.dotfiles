{...}: {
  programs.wofi = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      # This is an example Hyprland config file.
      # Refer to the wiki for more information.
      # https://wiki.hypr.land/Configuring/

      # Please note not all available settings / options are set here.
      # For a full list, see the wiki

      # You can split this configuration into multiple files
      # Create your files separately and then link them to this file like this:
      # source = ~/.config/hypr/myColors.conf


      ################
      ### MONITORS ###
      ################

      # See https://wiki.hypr.land/Configuring/Monitors/
      $moni_lg = LG Electronics LG Ultra HD 0x0000989C
      $moni_asus = ASUSTek COMPUTER INC VG248 M4LMQS244850
      $moni_dell = Dell Inc. DELL P2419HC 5784JQ2
      $moni_samsung = Samsung Electric Company LS27A800U HNMW900207
      $moni_lg_smj = LG Electronics 27MP75 0x00044A87

      monitor = eDP-1, 2880x1920@120, -1920x0, 1.5

      monitor = desc:$moni_lg, 3840x2160, +1920x-300, 1.5
      monitor = desc:$moni_asus, 1920x1080@144, 0x0, 1
      monitor = desc:$moni_dell, 1920x1080, -1080x-300, 1, transform, 1
      monitor = desc:$moni_samsung, 3840x2160, 0x0, 1.5
      monitor = desc:$moni_lg_smj, 1920x1080, 0x-1920, 1

      # Random monitors
      monitor = , preferred, 0x0, 1
      # monitor = , preferred, auto, 1, mirror, eDP-1

      # closed
      bindl=,switch:on:Lid Switch, exec, ~/.config/hypr/lid-handler.sh close
      # open
      bindl=,switch:off:Lid Switch, exec, ~/.config/hypr/lid-handler.sh open


      ###################
      ### MY PROGRAMS ###
      ###################

      # See https://wiki.hypr.land/Configuring/Keywords/

      # Set programs that you use
      $terminal = ghostty
      $fileManager = nautilus
      $menu = wofi --show drun
      $browser = zen


      #################
      ### AUTOSTART ###
      #################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:

      exec-once = waybar &
      exec-once = wl-paste --watch cliphist store &


      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hypr.land/Configuring/Environment-variables/

      env = HYPRCURSOR_THEME,rose-pine-hyprcursor
      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24


      ###################
      ### PERMISSIONS ###
      ###################

      # See https://wiki.hypr.land/Configuring/Permissions/
      # Please note permission changes here require a Hyprland restart and are not applied on-the-fly
      # for security reasons

      # ecosystem {
      #   enforce_permissions = 1
      # }

      # permission = /usr/(bin|local/bin)/grim, screencopy, allow
      # permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
      # permission = /usr/(bin|local/bin)/hyprpm, plugin, allow


      #####################
      ### LOOK AND FEEL ###
      #####################

      # Refer to https://wiki.hypr.land/Configuring/Variables/

      # https://wiki.hypr.land/Configuring/Variables/#general
      general {
          gaps_in = 4
          gaps_out = 8

          border_size = 2

          # https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false

          # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = dwindle
      }

      # https://wiki.hypr.land/Configuring/Variables/#decoration
      decoration {
          rounding = 10
          rounding_power = 2

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0
          inactive_opacity = 1.0

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }

          # https://wiki.hypr.land/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1

              vibrancy = 0.1696
          }
      }

      # https://wiki.hypr.land/Configuring/Variables/#animations
      animations {
          enabled = yes, please :)

          # Default animations, see https://wiki.hypr.land/Configuring/Animations/ for more

          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, almostLinear, fade
          animation = workspacesIn, 1, 1.21, almostLinear, fade
          animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      # Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
      # "Smart gaps" / "No gaps when only"
      # uncomment all if you wish to use that.
      # workspace = w[tv1], gapsout:0, gapsin:0
      # workspace = f[1], gapsout:0, gapsin:0
      # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
      # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
      # windowrule = bordersize 0, floating:0, onworkspace:f[1]
      # windowrule = rounding 0, floating:0, onworkspace:f[1]

      # See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # See https://wiki.hypr.land/Configuring/Master-Layout/ for more
      master {
          new_status = master
      }

      # https://wiki.hypr.land/Configuring/Variables/#misc
      misc {
          force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
      }


      #############
      ### INPUT ###
      #############

      # https://wiki.hypr.land/Configuring/Variables/#input
      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options = caps:escape
          kb_rules =

          follow_mouse = 1

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
              natural_scroll = true
          }
      }

      # https://wiki.hypr.land/Configuring/Variables/#gestures
      gestures {
          workspace_swipe = false
      }

      # Example per-device config
      # See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
      device {
        name = logitech-pro-x-1
        sensitivity = -1
      }
      device {
        name = logitech-wireless-mouse-mx-master-2s-1
        sensitivity = -0.7
      }


      ###################
      ### KEYBINDINGS ###
      ###################

      # See https://wiki.hypr.land/Configuring/Keywords/
      $mainMod = SUPER
      $shiftMod = SUPER_SHIFT

      # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
      bind = $mainMod, return, exec, $terminal
      bind = $mainMod, W, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, F, togglefloating,
      bind = $mainMod, space, exec, $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, N, togglesplit, # dwindle
      bind = $mainMod, B, exec, $browser
      bind = $shiftMod, L, exec, sh -c '(sleep 0.5s; hyprlock)' & disown
      bind = $mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

      bind = ALT SHIFT, 3, exec, hyprshot -m active -m output -o ~/Downloads
      bind = ALT SHIFT, 4, exec, hyprshot -m region -o ~/Downloads
      bind = ALT SHIFT, 5, exec, hyprshot -m active -m window -o ~/Downloads
      bind = ALT SHIFT, G, exec, sh -c 'gradia $(fd -e .png hyprshot ~/Downloads | tail -n 1)'

      # Move focus with mainMod + arrow keys
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $shiftMod, 1, movetoworkspace, 1
      bind = $shiftMod, 2, movetoworkspace, 2
      bind = $shiftMod, 3, movetoworkspace, 3
      bind = $shiftMod, 4, movetoworkspace, 4
      bind = $shiftMod, 5, movetoworkspace, 5
      bind = $shiftMod, 6, movetoworkspace, 6
      bind = $shiftMod, 7, movetoworkspace, 7
      bind = $shiftMod, 8, movetoworkspace, 8
      bind = $shiftMod, 9, movetoworkspace, 9
      bind = $shiftMod, 0, movetoworkspace, 10

      bind = CTRL $shiftMod, comma, movecurrentworkspacetomonitor, l
      bind = CTRL $shiftMod, period, movecurrentworkspacetomonitor, r

      # Example special workspace (scratchpad)
      # bind = $mainMod, S, togglespecialworkspace, magic
      # bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      # Scroll through existing workspaces with mainMod + scroll
      # bind = $mainMod, mouse_down, workspace, e+1
      # bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Laptop multimedia keys for volume and LCD brightness
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

      # Requires playerctl
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hypr.land/Configuring/Window-Rules/ for more
      # See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

      # Example windowrule
      # windowrule = float,class:^(kitty)$,title:^(kitty)$
      windowrule = float,class:^be\.alexandervanhee\.gradia$

      # Ignore maximize requests from apps. You'll probably like this.
      windowrule = suppressevent maximize, class:.*

      # Fix some dragging issues with XWayland
      windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    '';
  };

  xdg.configFile.lid-handler = {
    target = "./hypr/lid-handler.sh";
    executable = true;
    text = ''
      #!/usr/bin/env zsh

      # external monitors
      if [[ "$(hyprctl monitors)" =~ "\sDP-[0-9]+" ]]; then
          if [[ "$1" == "open" ]]; then
            hyprctl keyword monitor "eDP-1, 2880x1920@120, auto-left, 1.5"
          else
            hyprctl keyword monitor "eDP-1, disable"
          fi
      else
          if [[ "$1" == "open" ]]; then
            hyprctl keyword monitor "eDP-1, 2880x1920@120, auto-left, 1.5"
          else
            hyprlock --immediate & disown
            systemctl suspend
          fi
      fi
    '';
  };
}
