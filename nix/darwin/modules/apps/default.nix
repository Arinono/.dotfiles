{
  pkgs,
  params,
  secrets,
  ...
}: {
  imports = [
    ./homebrew.nix
    ./app-defaults
  ];
  
  # System packages for applications
  environment.systemPackages = with pkgs; [
    arc-browser
    brave
    obsidian
    spotify
  ];
}