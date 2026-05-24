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

  raycastQuicklinks = pkgs.writeShellApplication {
    name = "raycast-quicklinks";

    text = ''
      OUTDIR="$HOME/.config/raycast"
      mkdir -p "$OUTDIR"

      cat > "$OUTDIR/quicklinks.json" <<'EOF'
      [
        {"name":"Search Google","link":"https://google.com/search?q={argument}"},
        {"name":"Search DuckDuckGo","link":"https://duckduckgo.com/?q={argument}"},
        {"name":"vuetify","link":"https://vuetifyjs.com/en/api/{argument name=\"component\"}"},
        {"iconName":"blank-document-16","name":"devdocs","link":"http://devdocs.io/#q={docs}"},
        {"name":"dutch","link":"https://translate.google.com/?sl=auto&tl=nl&text={argument name=\"text\"}&op=translate"},
        {"name":"english","link":"https://translate.google.com/?sl=auto&tl=en&text={argument name=\"text\"}&op=translate"}
      ]
      EOF

      echo "Quicklinks written to $OUTDIR/quicklinks.json"
      echo "Import them in Raycast via: Preferences > Extensions > Quicklinks > Import Quicklinks"
    '';
  };
}
