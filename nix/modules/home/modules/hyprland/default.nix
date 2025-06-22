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
}
