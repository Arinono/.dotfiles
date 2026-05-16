{...}: {
  services.tailscale.extraUpFlags = [
    "--accept-routes"
    "--advertise-exit-node"
    "--advertise-routes=10.4.1.0/24,10.4.2.0/24"
    "--advertise-tags=tag:nodes-ams"
    "--operator=arinono"
  ];
}
