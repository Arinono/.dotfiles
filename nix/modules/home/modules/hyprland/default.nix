{...}: {
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./hyprlock.nix
    ./wofi.nix
  ];

  programs.wofi = {
    enable = true;
  };

  services.swaync.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/Wallpapers/kr_street.jpg"
        "~/Pictures/Wallpapers/kr_bridge.jpg"
        "~/Pictures/Wallpapers/tokyonight.png"
      ];

      wallpaper = [
        ",~/Pictures/Wallpapers/kr_bridge.jpg"
      ];
    };
  };
}
