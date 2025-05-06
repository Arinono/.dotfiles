{
  pkgs,
  params,
  ...
}: {
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "set-hostname";

      text = ''
        HOSTNAME=''${1:-$HOSTNAME}
        if [ -z "$HOSTNAME" ]; then
          echo "Error: No hostname provided"
          echo "Usage: nix run .#setHostname -- <hostname> or HOSTNAME=<value> nix run .#setHostname"
          exit 1
        fi

        sudo scutil --set HostName "$HOSTNAME"
        sudo scutil --set LocalHostName "$HOSTNAME"
        sudo scutil --set ComputerName "$HOSTNAME"
        dscacheutil -flushcache
      '';
    })
  ];
}