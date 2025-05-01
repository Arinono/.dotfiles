{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "ntfy";
    runtimeInputs = [pkgs.curl];

    text = ''
      set +o nounset

      topic=$1
      if [[ -z "$topic" ]]; then
        topic="cli"
      fi

      msg="$2"
      if [[ -z "$msg" ]]; then
        msg="$1"
        if [[ -z "$msg" ]]; then
          msg="done"
        fi
        msg="done"
      fi

      curl -u 'arinono:missing-token' -Ld "$msg" "https://ntfy.arino.io/$topic"
    '';
  };
}
