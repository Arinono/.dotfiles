{params, ...}: let
  machineMonitors = {
    urgot = ''
      hl.monitor({ output = "HEADLESS-2", disabled = true })
    '';
  };
  machineAutostart = {
    urgot = ''
      hl.exec_cmd("hyprctl output create headless")
    '';
  };
in {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = ''
      ---------------------
      --   MY PROGRAMS   --
      ---------------------

      -- Set programs that you use
      local terminal    = "ghostty"
      local fileManager = "nautilus"
      local menu        = "rofi"
      local dmenu       = 'rofi -dmenu -p ""'


      ------------------
      --   MONITORS   --
      ------------------

      local moni_dell      = "desc:Dell Inc. DELL P2419HC"
      local moni_samsung   = "desc:Samsung Electric Company LS27A800U"
      local moni_asus_oled = "desc:ASUSTek COMPUTER INC XG27AQDMG"

      hl.monitor({ output = "eDP-1", mode = "2880x1920@120", position = "-1920x0", scale = 1.5 })

      -- work
      hl.monitor({ output = moni_samsung, mode = "3840x2160", position = "0x0", scale = 1.5 })
      -- home
      hl.monitor({ output = moni_asus_oled, mode = "2560x1440@240", position = "0x0", scale = 1 })
      hl.monitor({ output = moni_dell, mode = "1920x1080", position = "-1080x-100", scale = 1, transform = 1 })

      -- Random monitors
      hl.monitor({ output = "", mode = "preferred", position = "0x0", scale = 1 })

      ${machineMonitors.${params.hostname} or ""}
      -- closed
      hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/lid-handler.sh close"), { locked = true })
      -- open
      hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/lid-handler.sh open"), { locked = true })


      -------------------
      --   AUTOSTART   --
      -------------------

      hl.on("hyprland.start", function()
          hl.exec_cmd("waybar")
          hl.exec_cmd("wl-paste --watch cliphist store")
      ${machineAutostart.${params.hostname} or ""}
      end)


      -------------------------------
      --   ENVIRONMENT VARIABLES   --
      -------------------------------

      hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")


      -----------------------
      --   LOOK AND FEEL   --
      -----------------------

      hl.config({
          general = {
              gaps_in     = 4,
              gaps_out    = 8,

              border_size = 2,

              col = {
                  active_border   = "rgb(7aa2f7)",
                  inactive_border = "rgb(1a1b26)",
              },

              -- Set to true enable resizing windows by clicking and dragging on borders and gaps
              resize_on_border = false,

              allow_tearing = false,

              layout = "dwindle",
          },

          decoration = {
              rounding       = 5,
              rounding_power = 2,

              active_opacity   = 1.0,
              inactive_opacity = 1.0,

              shadow = {
                  enabled      = true,
                  range        = 4,
                  render_power = 3,
                  color        = "rgba(1a1a1aee)",
              },

              blur = {
                  enabled  = true,
                  size     = 3,
                  passes   = 1,

                  vibrancy = 0.1696,
              },
          },
      })

      hl.config({ animations = { enabled = true } })

      hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
      hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
      hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
      hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

      hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
      hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
      hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
      hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
      hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
      hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

      hl.config({
          dwindle = {
              preserve_split = true, -- You probably want this
          },
      })

      hl.config({
          master = {
              new_status = "master",
          },
      })

      hl.config({
          misc = {
              force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
          },
      })


      ---------------
      --   INPUT   --
      ---------------

      hl.config({
          input = {
              kb_layout  = "us",
              kb_options = "caps:escape",

              follow_mouse = 1,

              sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

              touchpad = {
                  natural_scroll = true,
              },
          },
      })

      hl.config({
          gestures = {
              workspace_swipe_touch = false,
          },
      })

      -- Per-device config
      hl.device({
          name        = "logitech-pro-x-1",
          sensitivity = -1,
      })
      hl.device({
          name        = "mouse-passthrough",
          sensitivity = -1,
      })
      hl.device({
          name        = "logitech-wireless-mouse-mx-master-2s-1",
          sensitivity = -0.7,
      })


      ---------------------
      --   KEYBINDINGS   --
      ---------------------

      local mainMod  = "SUPER"
      local shiftMod = "SUPER + SHIFT"

      hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + W", hl.dsp.window.close())
      hl.bind(mainMod .. " + M", hl.dsp.exit())
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
      hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(shiftMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
      hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(menu .. " -show calc"))
      hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu .. " -show drun"))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
      hl.bind(mainMod .. " + L", hl.dsp.exec_cmd('rofi -show power-menu -modi "power-menu:rofi-power-menu --no-symbols --choices=suspend/lockscreen/logout/reboot/shutdown"'))
      hl.bind(shiftMod .. " + L", hl.dsp.exec_cmd("sh -c '(sleep 0.5s; hyprlock)'"))
      hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | " .. dmenu .. " | cliphist decode | wl-copy"))

      hl.bind("ALT + SHIFT + 2", hl.dsp.exec_cmd("hyprcap shot monitor -o ~/Downloads -w -c -n"))
      hl.bind("ALT + SHIFT + 3", hl.dsp.exec_cmd("hyprcap shot monitor:active -o ~/Downloads -w -c -n"))
      hl.bind("ALT + SHIFT + 4", hl.dsp.exec_cmd("hyprcap shot region -o ~/Downloads -w -c -n -z"))
      hl.bind("ALT + SHIFT + 5", hl.dsp.exec_cmd("hyprcap shot window:active -o ~/Downloads -w -c -n"))
      hl.bind("ALT + SHIFT + G", hl.dsp.exec_cmd([[bash -c 'gradia "$(ls -t ~/Downloads/*_hyprcap.png 2>/dev/null | head -n 1)"']]))

      -- Move focus with mainMod + hjkl
      hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
      hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
      hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
      hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

      -- Switch workspaces with mainMod + [0-9]
      -- Move active window to a workspace with mainMod + SHIFT + [0-9]
      for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind(shiftMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(shiftMod .. " + CTRL + comma", hl.dsp.workspace.move({ monitor = "l" }))
      hl.bind(shiftMod .. " + CTRL + period", hl.dsp.workspace.move({ monitor = "r" }))

      -- Move/resize windows with mainMod + LMB/RMB and dragging
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Laptop multimedia keys for volume and LCD brightness
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

      -- Requires playerctl
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


      --------------------------------
      --   WINDOWS AND WORKSPACES   --
      --------------------------------

      -- Ignore maximize requests from apps. You'll probably like this.
      hl.window_rule({
          name           = "suppress-maximize",
          match          = { class = ".*" },
          suppress_event = "maximize",
      })

      -- Fix some dragging issues with XWayland
      hl.window_rule({
          name  = "no-focus",
          match = {
              class      = "^$",
              title      = "^$",
              xwayland   = true,
              float      = true,
              fullscreen = false,
              pin        = false,
          },

          no_focus = true,
      })

      -- Floating PiP windows, pinned bottom-right without stealing focus
      local function pipRule(name, titleMatch)
          return hl.window_rule({
              name  = name,
              match = { title = titleMatch },

              float            = true,
              pin              = true,
              monitor          = "0",
              animation        = "slide right",
              move             = { "(monitor_w-window_w-8)", "57" },
              no_initial_focus = true,
          })
      end

      pipRule("pip", "^(Picture-in-Picture)$")
      pipRule("pip-twitch", "^(Twitch — Zen Browser)$")

      -- Windows tagged float_cursor open floating, centered under the cursor
      hl.window_rule({ name = "tag-gradia",     match = { class = [[^(be\.alexandervanhee\.gradia)$]] }, tag = "+float_cursor" })
      hl.window_rule({ name = "tag-calculator", match = { class = "^(org.gnome.Calculator)$" }, tag = "+float_cursor", size = { 470, 340 } })
      hl.window_rule({ name = "tag-clocks",     match = { class = "^(org.gnome.clocks)$" },     tag = "+float_cursor", size = { 420, 630 } })

      hl.window_rule({
          name  = "float-cursor",
          match = { tag = "float_cursor" },

          float     = true,
          animation = "popin",
          move      = { "(cursor_x-(window_w*0.5))", "(cursor_y-(window_h*0.5))" },
      })

      -- Games keep rendering when unfocused
      hl.window_rule({ name = "tag-gamescope", match = { class = "^(gamescope)$" },        tag = "+games" })
      hl.window_rule({ name = "tag-steam-app", match = { class = [[^(steam_app_\d+)$]] },  tag = "+games" })

      hl.window_rule({
          name  = "games",
          match = { tag = "games" },

          render_unfocused = true,
      })

      hl.window_rule({
          name  = "bigpicture",
          match = {
              class = "^(steam)$",
              title = "^(Steam Big Picture Mode)$",
          },

          content    = "game",
          workspace  = "10",
          fullscreen = true,
      })

      hl.window_rule({
          name  = "friends",
          match = {
              class = "^(steam)$",
              title = "^(Friends List)$",
          },

          float     = true,
          animation = "popin",
          size      = { 630, 880 },
      })

    '';
  };

  xdg.configFile.lid-handler = {
    target = "./hypr/lid-handler.sh";
    executable = true;
    text = ''
      #!/usr/bin/env zsh

      -- external monitors
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
