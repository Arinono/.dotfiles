{
  pkgs,
  lib,
  ...
}: {
  nix = {
    enable = true;
    package = pkgs.nix;

    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["arinono" "@admin"];
      max-jobs = "auto";

      builders-use-substitutes = true;
      builders = lib.mkForce [
        "aatrox aarch64-linux ~/.ssh/id_ed25519 4 1 ; ahri x86_64-linux ~/.ssh/id_ed25519 4 1"
      ];

      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
