{
  params,
  pkgs,
  ...
}: let
  hwmonPath =
    if params.hostname == "viktor"
    then "/sys/class/hwmon/hwmon5/temp1_input"
    else if params.hostname == "urgot"
    then "/sys/class/hwmon/hwmon2/temp1_input"
    else "";
in {
  programs.waybar = {
    enable = true;
  };

  xdg.configFile.waybar-config = {
    target = "./waybar/config.jsonc";
    text = ''
      {
        "layer": "top",
        "position": "top",
        "reload-style-on-change": true,
        "modules-left": [
          "hyprland/workspaces"
        ],
        "modules-center": [
          "clock"
        ],
        "modules-right": [
          "pulseaudio",
          "bluetooth",
          "network",
          "cpu",
          "memory",
          "temperature",
          "battery",
          "power-profiles-daemon",
          "idle_inhibitor",
          "custom/lock",
          "custom/sleep"
        ],
        "hyprland/workspaces": {
          "format": "{name}: {icon}",
          "format-icons": {
            "active": "",
            "default": ""
          }
        },
        "clock": {
          "timezone": "Europe/Amsterdam",
          "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
          "format": "{:%d - %H:%M}"
        },
        "bluetooth": {
          "format": "󰂯",
          "format-disabled": "󰂲",
          "format-connected": "󰂱 {device_alias}",
          "format-connected-battery": "󰂱 {device_alias} (󰥉 {device_battery_percentage}%)",
          // "format-device-preference": [ "device1", "device2" ], // preference list deciding the displayed device
          "tooltip-format": "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected",
          "tooltip-format-disabled": "bluetooth off",
          "tooltip-format-connected": "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected\n\n{device_enumerate}",
          "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}",
          "tooltip-format-enumerate-connected-battery": "{device_alias}\t{device_address}\t({device_battery_percentage}%)",
          "max-length": 35,
          "on-click": "${pkgs.overskride}/bin/overskride"
        },
        "network": {
          "format-wifi": "󰤢 ",
          "format-ethernet": "󰈀 ",
          "format-disconnected": "󰤠 ",
          "interval": 5,
          "tooltip": false,
          "on-click": "${pkgs.networkmanagerapplet}/bin/nm-connection-editor"
        },
        "cpu": {
          "interval": 1,
          "format": "  {usage:>2}%"
        },
        "memory": {
          "interval": 10,
          "format": "  {used:0.1f}G"
        },
        "pulseaudio": {
          "format": "{icon} {volume}%",
          "format-muted": "",
          "format-icons": {
            "default": ["", "", " "]
          },
          "on-click": "${pkgs.pavucontrol}/bin/pavucontrol"
        },
        "temperature": {
          "critical-threshold": 80,
          "warning-threshold": 50,
          "hwmon-path": "${hwmonPath}",
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
          "format-charging": "{capacity}% ",
          "format-plugged": "{capacity}% ",
          "format-alt": "{time} {icon}",
          "format-icons": ["", "", "", "", ""]
        },
        "idle_inhibitor": {
          "format": "{icon}",
          "format-icons": {
            "activated": "",
            "deactivated": ""
          }
        },
        "power-profiles-daemon": {
          "format": "{icon}",
          "tooltip-format": "Power profile: {profile}",
          "tooltip": true,
          "format-icons": {
            "default": "",
            "performance": "",
            "balanced": "",
            "power-saver": ""
          }
        },
        "custom/lock": {
          "tooltip": false,
          "on-click": "sh -c '(sleep 0.5s; ${pkgs.hyprlock}/bin/hyprlock)' & disown",
          "format": ""
        },
        "custom/sleep": {
          "tooltip": false,
          "on-click": "sh -c '(sleep 0.5s; systemctl suspend)'",
          "format": "🛏"
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

        #backlight,
        #clock,
        #battery,
        #pulseaudio,
        #network,
        #bluetooth,
        #cpu,
        #memory,
        #temperature,
        #idle_inhibitor,
        #power-profiles-daemon,
        #custom-lock,
        #custom-sleep,
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

        #custom-sleep {
          border-radius: 0 7px 7px 0;
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

        #pulseaudio {
          color: #ea999c;
        }

        #custom-lock,
        #custom-sleep,
        #idle_inhibitor.activated,
        #power-profiles-daemon,
        #power-profiles-daemon.balanced {
          color: #babbf1;
        }

        #power-profiles-daemon.performance {
          color: #ea999c;
        }

        #power-profiles-daemon.power-saver {
          color: #a6d189;
        }

        #custom-power {
          margin-right: 1rem;
          color: #e78284;
        }

        #temperature {
          color: #a6d189;
        }

        #temperature.warning {
          color: #f0932b;
        }

        #temperature.critical {
          color: #eb4d4b;
        }
    '';
  };
}
