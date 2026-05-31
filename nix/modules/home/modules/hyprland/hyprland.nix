{params, ...}: let
  machineExtras = {
    urgot = ''
      hl.monitor({ output = "HEADLESS-2", disabled = true })
      hl.on("hyprland.start", function()
        hl.exec_cmd("hyprctl output create headless")
      end)
    '';
  };
in {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = ''
      -- This is an example Hyprland Lua config file.
      -- Refer to the wiki for more information.
      -- https://wiki.hypr.land/Configuring/Start/

      ------------------
      ---- MONITORS ----
      ------------------

      -- See https://wiki.hypr.land/Configuring/Basics/Monitors/

      local moni_lg        = "LG Electronics LG Ultra HD 0x0000989C"
      local moni_asus      = "ASUSTeK COMPUTER INC VG248 M4LMQS244850"
      local moni_dell      = "Dell Inc. DELL P2419HC 5784JQ2"
      local moni_samsung   = "Samsung Electric Company LS27A800U HNMW900207"
      local moni_lg_smj    = "LG Electronics 27MP75 0x00044A87"
      local moni_asus_oled = "ASUSTeK COMPUTER INC XG27AQDMG T7LMRS037655"

      hl.monitor({ output = "eDP-1", mode = "2880x1920@120", position = "-1920x0", scale = 1.5 })

      -- hl.monitor({ output = "desc:" .. moni_lg, mode = "3840x2160", position = "1920x-300", scale = 1.5 })
      -- hl.monitor({ output = "desc:" .. moni_asus, mode = "1920x1080@144", position = "0x0", scale = 1 })
      hl.monitor({ output = "desc:" .. moni_asus_oled, mode = "2560x1440@240", position = "0x0", scale = 1 })
      hl.monitor({ output = "desc:" .. moni_dell, mode = "1920x1080", position = "-1080x-100", scale = 1, transform = 1 })
      hl.monitor({ output = "desc:" .. moni_samsung, mode = "3840x2160", position = "0x0", scale = 1.5 })
      hl.monitor({ output = "desc:" .. moni_lg_smj, mode = "1920x1080", position = "0x-1920", scale = 1 })

      hl.monitor({ output = "", mode = "preferred", position = "0x0", scale = 1 })
      -- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })

      -- closed
      hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/lid-handler.sh close"), { locked = true })
      -- open
      hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/lid-handler.sh open"), { locked = true })


      ---------------------
      ---- MY PROGRAMS ----
      ---------------------

      -- Set programs that you use
      local terminal    = "ghostty"
      local fileManager = "nautilus"
      local menu        = "rofi"
      local dmenu       = "rofi -dmenu -p \"\""


      -------------------
      ---- AUTOSTART ----
      -------------------

      -- See https://wiki.hypr.land/Configuring/Basics/Autostart/

      hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
        hl.exec_cmd("wl-paste --watch cliphist store")
        ${machineExtras.${params.hostname} or ""}
      end)


      -------------------------------
      ---- ENVIRONMENT VARIABLES ----
      -------------------------------

      -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

      hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")


      -----------------------
      ----- PERMISSIONS -----
      -----------------------

      -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
      -- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
      -- for security reasons

      -- hl.config({
      --   ecosystem = {
      --     enforce_permissions = true,
      --   },
      -- })

      -- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
      -- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
      -- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


      -----------------------
      ---- LOOK AND FEEL ----
      -----------------------

      -- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

      hl.config({
        general = {
          gaps_in = 4,
          gaps_out = 8,

          border_size = 2,

          -- https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
          -- col = {
          --   active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
          --   inactive_border = "rgba(595959aa)",
          -- }
          col = {
            active_border   = "rgb(7aa2f7)",
            inactive_border = "rgb(1a1b26)",
          },

          -- Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false,

          -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
          allow_tearing = false,

          layout = "dwindle",
        },

        decoration = {
          rounding = 5,
          rounding_power = 2,

          -- Change transparency of focused and unfocused windows
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

        animations = {
          enabled = true,
        },
      })

      -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
      hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
      hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
      hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
      hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

      hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
      hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
      hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
      hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
      hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
      hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })

      -- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
      -- "Smart gaps" / "No gaps when only"
      -- uncomment all if you wish to use that.
      -- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
      -- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
      -- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
      -- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
      -- hl.window_rule({ match = { float = false, workspace = "f[1]" },   border_size = 0 })
      -- hl.window_rule({ match = { float = false, workspace = "f[1]" },   rounding = 0 })

      -- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
      hl.config({
        dwindle = {
          preserve_split = true,
        },
      })

      -- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
      hl.config({
        master = {
          new_status = "master",
        },
      })

      -- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
      hl.config({
        misc = {
          force_default_wallpaper = -1,
          disable_hyprland_logo = false,
        },
      })


      -------------
      ---- INPUT ----
      -------------

      -- https://wiki.hypr.land/Configuring/Basics/Variables/#input
      hl.config({
        input = {
          kb_layout  = "us",
          kb_variant = "",
          kb_model   = "",
          kb_options = "caps:escape",
          kb_rules   = "",

          follow_mouse = 1,

          sensitivity = 0,

          touchpad = {
            natural_scroll = true,
          },
        },
      })

      -- https://wiki.hypr.land/Configuring/Basics/Variables/#gestures
      hl.config({
        gestures = {
          workspace_swipe_touch = false,
        },
      })

      -- Example per-device config
      -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
      hl.device({
        name        = "logitech-pro-x-1",
        sensitivity = -1,
      })
      hl.device({
        name        = "logitech-wireless-mouse-mx-master-2s-1",
        sensitivity = -0.7,
      })


      ---------------------
      ---- KEYBINDINGS ----
      ---------------------

      -- See https://wiki.hypr.land/Configuring/Basics/Binds/
      local mainMod  = "SUPER"
      local shiftMod = "SUPER + SHIFT"

      -- Example binds
      hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + W", hl.dsp.window.close())
      hl.bind(mainMod .. " + M", hl.dsp.exit())
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
      hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(shiftMod .. " + F", hl.dsp.window.fullscreen())
      hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(menu .. " -show calc"))
      hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu .. " -show drun"))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
      hl.bind(shiftMod .. " + L", hl.dsp.exec_cmd("sh -c '(sleep 0.5s; hyprlock)' & disown"))
      hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | " .. dmenu .. " | cliphist decode | wl-copy"))

      hl.bind("ALT + SHIFT + 2", hl.dsp.exec_cmd("hyprcap shot monitor -o ~/Downloads -w -c -n"))
      hl.bind("ALT + SHIFT + 3", hl.dsp.exec_cmd("hyprcap shot monitor:active -o ~/Downloads -w -c -n"))
      hl.bind("ALT + SHIFT + 4", hl.dsp.exec_cmd("hyprcap shot region -o ~/Downloads -w -c -n -z"))
      hl.bind("ALT + SHIFT + 5", hl.dsp.exec_cmd("hyprcap shot window:active -o ~/Downloads -w -c -n"))
      hl.bind("ALT + SHIFT + G", hl.dsp.exec_cmd("bash -c 'gradia \"$(ls -t ~/Downloads/*_hyprcap.png 2>/dev/null | head -n 1)\"'"))

      -- Move focus with mainMod + arrow keys
      hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

      -- Switch workspaces with mainMod + [0-9]
      -- Move active window to a workspace with mainMod + SHIFT + [0-9]
      for i = 1, 10 do
        local key = i % 10
        hl.bind(mainMod .. " + " .. key,  hl.dsp.focus({ workspace = i }))
        hl.bind(shiftMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind("CTRL + " .. shiftMod .. " + comma",  hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l"))
      hl.bind("CTRL + " .. shiftMod .. " + period", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r"))

      -- Example special workspace (scratchpad)
      -- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
      -- hl.bind(shiftMod .. " + S",         hl.dsp.window.move({ workspace = "special:magic" }))

      -- Scroll through existing workspaces with mainMod + scroll
      -- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      -- hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

      -- Move/resize windows with mainMod + LMB/RMB and dragging
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Laptop multimedia keys for volume and LCD brightness
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
      hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                     { locked = true, repeating = true })

      -- Requires playerctl
      hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
      hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


      --------------------------------
      ---- WINDOWS AND WORKSPACES ----
      --------------------------------

      -- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
      -- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules

      -- Ignore maximize requests from apps. You'll probably like this.
      hl.window_rule({
        name  = "suppress-maximize-events",
        match = { class = ".*" },
        suppress_event = "maximize",
      })

      -- Fix some dragging issues with XWayland
      hl.window_rule({
        name = "fix-xwayland-drags",
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

      hl.window_rule({
        name = "pip",
        match = { title = "^(Picture-in-Picture)$" },
        float            = true,
        pin              = true,
        monitor          = "0",
        animation        = "slide right",
        move             = { "monitor_w-window_w-8", "57" },
        no_initial_focus = true,
      })

      hl.window_rule({ match = { class = "^(be\\.alexandervanhee\\.gradia)$" }, tag = "+float_cursor" })
      hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" },     tag = "+float_cursor", size = { 470, 340 } })
      hl.window_rule({ match = { class = "^(org\\.gnome\\.clocks)$" },          tag = "+float_cursor", size = { 420, 630 } })

      hl.window_rule({
        name = "float_cursor",
        match = { tag = "float_cursor" },
        float     = true,
        animation = "popin",
        move      = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" },
      })

      hl.window_rule({ match = { class = "^(gamescope)$" },        tag = "+games" })
      hl.window_rule({ match = { class = "^(steam_app_\\d+)$" }, tag = "+games" })

      hl.window_rule({
        name = "games",
        match = { tag = "games" },
        render_unfocused = true,
      })

      hl.window_rule({
        name = "bigpicture",
        match = {
          class = "^(steam)$",
          title = "^(Steam Big Picture Mode)$",
        },
        content    = "game",
        workspace  = "10",
        fullscreen = true,
      })
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
