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
          "custom/lock"
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
          "on-click": "overskride"
        },
        "network": {
          "format-wifi": "󰤢 ",
          "format-ethernet": "󰈀 ",
          "format-disconnected": "󰤠 ",
          "interval": 5,
          "tooltip": false,
          "on-click": "$XDG_CONFIG_HOME/waybar/wifi.sh"
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
          "on-click": "pavucontrol"
        },
        "temperature": {
          "critical-threshold": 80,
          "hwmon-path": "/sys/class/hwmon/hwmon5/temp1_input",
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
          "on-click": "sh -c '(sleep 0.5s; hyprlock)' & disown",
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
          color: #f0932b;
        }

        #temperature.critical {
          color: #eb4d4b;
        }
    '';
  };

  xdg.configFile.wifi = {
    target = "./waybar/wifi.sh";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      connect_wifi() {
          notify-send "Fetching available Wi-Fi networks ..." -t 3000 -r 9991 -u normal

          current=$(nmcli -t -f active,ssid dev wifi | awk -F: '/^yes/ {print $2}')
          wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

          if [ -n "$current" ]; then
              wifi_list=$(echo "$wifi_list" | grep -v "$current")
              wifi_list="󰖩  $current [Connected]\n$wifi_list"
          fi

          choice=$(echo -e "$toggle\n$wifi_list" | uniq -u | wofi -dmenu -i -p "  Wifi" -selected-row 1 -config "$HOME/.config/wofi/regular.rasi")

          if [ -z "$choice" ]; then
              exit
          fi

          ssid=$(echo "$choice" | awk '{$1=""; print $0}' | sed 's/^ *//' | sed 's/ \[connected\]//')

          if [[ "$choice" = "$toggle" ]]; then
              nmcli radio wifi off
              notify-send "Wi-Fi Disabled" -r 9991 -u normal -t 5000
              exit
          fi

          if [[ "$ssid" = "$current" ]]; then
              notify-send "Already connected to $ssid" -r 9991 -u normal -t 5000
              exit
          else
              saved=$(nmcli -g NAME connection)
              if [[ $(echo "$saved" | grep -w "$ssid") = "$ssid" ]]; then
                  nmcli connection up id "$ssid" | grep "successfully" && notify-send "Connection Established" "Connected to $ssid" -t 5000 -r 9991 && exit
              fi
              if [[ "$choice" =~ "" ]]; then
                  password=$(wofi -dmenu -p "Password: " -l 0 -config "$HOME/.config/wofi/regular.rasi")
              fi
              if nmcli device wifi connect "$ssid" password "$password" | grep "successfully"; then
                  notify-send "Connection Established" "Connected to $ssid" -t 5000 -r 9991
              else
                  notify-send "Connection Failed" "Could not connect to $ssid" -t 5000 -r 9991
              fi
          fi
      }

      status=$(nmcli -fields WIFI g | sed -n 2p)
      if [[ "$status" =~ "enabled" ]]; then
          toggle="󰖪  Disable Wi-Fi"
          flag=1
      elif [[ "$status" =~ "disabled" ]]; then
          toggle="󰖩  Enable Wi-Fi"
          flag=0
      fi

      if [ "$flag" -eq 1 ]; then
          connect_wifi
      else
          choice=$(echo -e "$toggle" | wofi -dmenu -i -p "  Wifi" -config "$HOME/.config/wofi/regular.rasi")
          if [[ "$choice" = "$toggle" ]]; then
              nmcli radio wifi on
              toggle="󰖪  Disable Wi-Fi"
              notify-send "Wi-Fi Enabled" -r 9991 -u normal -t 5000
              sleep 2
              connect_wifi
          fi
      fi
    '';
  };
}
