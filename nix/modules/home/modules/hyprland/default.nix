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

      # "~/.dotfiles/Wallpapers/kr_street.jpg"
      # "~/.dotfiles/Wallpapers/kr_bridge.jpg"
      # "~/.dotfiles/Wallpapers/tokyonight.png"
      # "~/.dotfiles/Wallpapers/mikuos.jpg"
      wallpaper = [
        {
          monitor = "";
          path = "~/.dotfiles/Wallpapers/mikuos.jpg";
        }
      ];
    };
  };
}
