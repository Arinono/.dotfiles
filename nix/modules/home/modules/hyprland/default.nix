{...}: {
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./hyprlock.nix
  ];

  programs.wofi = {
    enable = true;
  };

  services.swaync.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/Wallpapers/kr_street.jpg"
        "~/Pictures/Wallpapers/kr_bridge.jpg"
        "~/Pictures/Wallpapers/tokyonight.png"
      ];

      wallpaper = [
        ",~/Pictures/Wallpapers/kr_street.jpg"
      ];
    };
  };
}
