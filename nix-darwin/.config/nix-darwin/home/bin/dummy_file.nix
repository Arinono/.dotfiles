{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "dummy_file";
    runtimeInputs = [pkgs.toybox];

    text = ''
      set +o nounset

      size="$1"
      name="$2"

      if [[ -z "$1" ]]; then
        size=5
      fi

      if [[ -z "$2" ]]; then
        name="dummy_file.txt"
      fi

      dd if=/dev/zero of="$name" bs=1048576 count="$size" &>/dev/null
      echo "Created $(pwd)/$name with size $size MB"
    '';
  };
}
