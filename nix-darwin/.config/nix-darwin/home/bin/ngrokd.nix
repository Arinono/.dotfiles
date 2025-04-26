{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "ngrokd";
    runtimeInputs = [pkgs.ngrok];

    text = ''
      if [[ -z $1 ]]; then
        echo "Usage: ngrokd <proto>"
        return 1
      fi

      if [[ -z $2 ]]; then
        echo "Usage: ngrokd <proto> <port>"
        return 1
      fi

      ngrok "$1" --domain="$NGROK_DOMAIN" "$2"
    '';
  };
}
