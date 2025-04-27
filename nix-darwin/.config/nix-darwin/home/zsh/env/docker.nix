{pkgs, ...}: {
  denter = pkgs.writeShellApplication {
    name = "denter";
    runtimeInputs = [pkgs.docker];

    text = ''
      if [[ ! "$1" ]]; then
        echo "You must supply a container ID or name"
        return 1
      fi

      docker exec -it "$1" bash
    '';
  };

  aliases = with pkgs; {
    doc = "${docker}/bin/docker";
    dcc = "${docker}/bin/docker compose";
    # Not tested
    ctop = "TERM=\"$${TERM/#tmux/screen}\" ${ctop}/bin/ctop";
  };
}
