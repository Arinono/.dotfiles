{
  pkgs,
  ...
}: {
  imports = [
    ../../services/aerospace.nix
    ../../services/sketchybar.nix
  ];
}