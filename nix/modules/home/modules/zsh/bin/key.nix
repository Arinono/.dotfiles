{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "key";
    runtimeInputs = [pkgs.toybox];

    text = ''
      set +o nounset
      len=$1

      if [[ -z $len ]]; then
        len=32
      fi

      head -c "$len" /dev/urandom | xxd -p -c "$len"
    '';
  };
}
