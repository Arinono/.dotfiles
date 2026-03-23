{
  inputs,
  pkgs,
  ...
}: let
  hyprcap = pkgs.callPackage ../pkgs/hyprcap {};
in {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    inputs.rose-pine-hyprcursor.packages.${stdenv.hostPlatform.system}.default

    # screenshot/recording tools
    hyprcap
    grim
    slurp
    hyprpicker
    wf-recorder

    # hyprland ecosystem
    brightnessctl
    playerctl
    wl-clipboard
    cliphist
    libnotify
    hyprlock

    # waybar dependencies
    pavucontrol
    overskride

    # screenshot editing
    gradia
  ];
}
