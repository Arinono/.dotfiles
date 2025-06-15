{pkgs}: {
  installBrew = with pkgs;
    pkgs.writeShellApplication {
      name = "install-homebrew";
      runtimeInputs = [bash curl];

      text = ''
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      '';
    };

  setHostname = pkgs.writeShellApplication {
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
  };
}
