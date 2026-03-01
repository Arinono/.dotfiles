{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./hyprlock.nix
    # ./wofi.nix
  ];

  programs.wofi = {
    enable = false;
  };

  programs.rofi = with pkgs; {
    enable = false;
    terminal = "${ghostty}/bin/ghostty";
  };

  programs.fuzzel = with pkgs; {
    enable = true;
    settings = {
      main = {
        terminal = "${ghostty}/bin/ghostty";
        layer = "overlay";
        width = "80";
        lines = "25";
        horizontal-pad = "8";
      };
      colors = {
        background = "1f2335ff";
        text = "c0caf5ff";
        match = "2ac3deff";
        selection = "363d59ff";
        selection-match = "2ac3deff";
        selection-text = "c0caf5ff";
        border = "29a4bdff";
      };
    };
  };

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
