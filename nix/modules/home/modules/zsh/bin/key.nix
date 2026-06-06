{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "key";
    runtimeInputs = [pkgs.toybox pkgs.coreutils];

    text = ''
      set +o nounset
      len=32
      mode="hex"

      while [[ $# -gt 0 ]]; do
        case "$1" in
          -b|--base64)
            mode="base64"
            shift
            ;;
          -h|--help)
            echo "Usage: key [LENGTH] [-b|--base64]"
            echo "Generate a random key of specified byte length."
            echo ""
            echo "Options:"
            echo "  -b, --base64  Output in base64 instead of hex"
            echo "  LENGTH        Key length in bytes (default: 32)"
            exit 0
            ;;
          *)
            if [[ "$1" =~ ^[0-9]+$ ]]; then
              len=$1
            fi
            shift
            ;;
        esac
      done

      if [[ "$mode" == "base64" ]]; then
        head -c "$len" /dev/urandom | base64 -w0
      else
        head -c "$len" /dev/urandom | xxd -p -c "$len"
      fi
    '';
  };
}
