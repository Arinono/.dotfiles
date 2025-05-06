{
  pkgs,
  params,
  ...
}: {
  imports = [
    ./general.nix
    ./global.nix
    ./dock_finder.nix
  ];
}