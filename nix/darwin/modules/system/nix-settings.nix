{
  pkgs,
  lib,
  params,
  ...
}: {
  nix = {
    enable = true;
    package = pkgs.nix;

    settings.experimental-features = "nix-command flakes";
    settings.trusted-users = ["${params.username}" "@admin"];
    settings.max-jobs = "auto";
    settings.builders-use-substitutes = true;
  };

  ids.gids.nixbld = 350;
}