{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "portscan";
    runtimeInputs = [pkgs.parallel pkgs.toybox pkgs.ripgrep];

    text = ''
      set +o nounset

      ip=$1

      if [[ -z $1 ]]; then
        ip="127.0.0.1"
      fi

      parallel nc -v -z "$ip" {} 2>&1 ::: 1-10000 10001-20000 20001-30000 30001-40000 40001-50000 50001-65535 | rg '^Connection'
    '';
  };
}
