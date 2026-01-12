{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
  networking.firewall.trustedInterfaces = ["tailscale0"];

  services.tailscale = {
    enable = true;
    authKeyFile = ./secrets/tailscale_key;
  };
}
