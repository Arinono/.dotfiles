{...}: {
  programs.waybar = {
    enable = true;
  };

  xdg.configFile.waybar-config = {
    target = "./waybar/config.jsonc";
    text = ''
      {
        "layer": "top",
        "position": "top",
        "modules-left": [
          "hyprland/workspaces"
        ],
        "modules-center": ["clock"],
        "modules-right": [
          "pulseaudio",
          "network",
          "cpu",
          "memory",
          "tray",
          "temperature",
          "battery",
          "custom/lock"
        ],
        "hyprland/workspaces": {
          "format": "{name}: {icon}",
          "format-icons": {
            "active": "",
            "default": ""
          }
        },
        "tray": {
          "icon-size": 18,
          "spacing": 8
        },
        "clock": {
          "timezone": "Europe/Amsterdam",
          "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
          "format": "{:%d - %H:%M}"
        },
        "network": {
          "format-wifi": "󰤢 ",
          "format-ethernet": "󰈀 ",
          "format-disconnected": "󰤠 ",
          "interval": 5,
          "tooltip": false
        },
        "cpu": {
          "interval": 1,
          "format": "  {icon0}{icon1}{icon2}{icon3} {usage:>2}%",
          "format-icons": ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
        },
        "memory": {
          "interval": 30,
          "format": "  {used:0.1f}G/{total:0.1f}G"
        },
        "pulseaudio": {
          "format": "{icon} {volume}%",
          "format-muted": "",
          "format-icons": {
            "default": ["", "", " "]
          },
          "on-click": "pavucontrol"
        },
        "temperature": {
          "critical-threshold": 80,
          "format": "{temperatureC}°C {icon}",
          "format-icons": [""]
        },
        "battery": {
          "states": {
              "good": 95,
              "warning": 30,
              "critical": 15
          },
          "format": "{capacity}% {icon}",
          "format-full": "{capacity}% {icon}",
          "format-charging": "{capacity}% ",
          "format-plugged": "{capacity}% ",
          "format-alt": "{time} {icon}",
          "format-icons": ["", "", "", "", ""]
        },
        "custom/lock": {
          "tooltip": false,
          "on-click": "sh -c '(sleep 0.5s; hyprlock)' & systemctl suspend & disown",
          "format": ""
        }
      }
    '';
  };

  xdg.configFile.waybar-style = {
    target = "./waybar/style.css";
    text = ''
      * {
          font-family: JetbrainsMono Nerd Font;
          font-size: 16;
          min-height: 0;
          padding-right: 2px;
          padding-left: 2px;
          padding-bottom: 0px;
        }

        #waybar {
          background: transparent;
          color: #c6d0f5;
          margin: 0;
          border-radius: 7px;
        }

        #workspaces {
          border-radius: 5px;
          margin: 5px;
          background: #101010;
          margin-left: 1rem;
        }

        #workspaces button {
          color: #babbf1;
          border-radius: 5px;
          padding: 0.4rem;
        }

        #workspaces button.active {
          color: #99d1db;
          border-radius: 5px;
        }

        #workspaces button:hover {
          color: #85c1dc;
          border-radius: 5px;
        }

        #custom-music,
        #tray,
        #backlight,
        #clock,
        #battery,
        #pulseaudio,
        #network,
        #cpu,
        #memory,
        #temperature,
        #custom-lock,
        #custom-power {
          background-color: #101010;
          padding: 0.5rem 1rem;
          margin: 5px 0;
        }

        #clock,
        #workspaces {
          border-radius: 7px;
        }
        #pulseaudio {
          border-radius: 7px 0 0 7px;
        }
        #custom-lock {
          border-radius: 0 7px 7px 0;
        }

        #memory {
        }

        #clock {
          color: #8caaee;
        }

        #battery {
          color: #a6d189;
        }

        #battery.charging {
          color: #a6d189;
        }

        #battery.warning:not(.charging) {
          color: #e78284;
        }

        #backlight {
          color: #e5c890;
        }

        #backlight,
        #battery {
          border-radius: 0;
        }

        #pulseaudio {
          color: #ea999c;
        }

        #custom-music {
          color: #ca9ee6;
        }

        #custom-lock {
          color: #babbf1;
        }

        #custom-power {
          margin-right: 1rem;
          color: #e78284;
        }

        #temperature {
          color: #f0932b;
        }

        #temperature.critical {
          color: #eb4d4b;
        }
    '';
  };
}
