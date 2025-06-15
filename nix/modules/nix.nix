{
  pkgs,
  lib,
  ...
}: {
  nix = {
    enable = true;
    package = pkgs.nix;

    settings.experimental-features = "nix-command flakes";
    settings.trusted-users = ["arinono" "@admin"];
    settings.max-jobs = "auto";
    settings.builders-use-substitutes = true;

    settings.builders = lib.mkForce [
      "aatrox aarch64-linux /var/root/.ssh/remotebuild 4 1 ; ahri x86_64-linux /var/root/.ssh/remotebuild 4 1"
    ];
  };
}
