{
  pkgs,
  lib,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
    # gamescopeSession.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  # programs.gamescope = {
  #   enable = true;
  #   capSysNice = true;
  # };

  environment.systemPackages = with pkgs; [
    steam
    steam-run
    steamcmd
  ];

  hardware.steam-hardware.enable = true;
}
