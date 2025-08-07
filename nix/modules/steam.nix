{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    steam
    steam-run-native
    steamcmd
  ];

  hardware.steam-hardware.enable = true;
}
