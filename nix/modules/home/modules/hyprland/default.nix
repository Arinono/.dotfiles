{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./hyprlock.nix
    ./launchers.nix
  ];

  services.swaync.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;

      # "~/Pictures/Wallpapers/kr_street.jpg"
      # "~/Pictures/Wallpapers/kr_bridge.jpg"
      # "~/Pictures/Wallpapers/tokyonight.png"
      wallpaper = [
        {
          monitor = "";
          path = "~/Pictures/Wallpapers/kr_bridge.jpg";
        }
      ];
    };
  };
}
