{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "vmrss";
    # native ps on macos and pkgs.ps on linux ?
    runtimeInputs = [pkgs.toybox pkgs.gawk pkgs.fzf];

    text = ''
      set +o nounset

      print_vmrss() {
        total=0
        unset arr
        declare -a arr
        arr=("$1" 0)

        while [ ''${#arr[@]} -gt 0 ]; do
          pid="''${arr[0]}"
          space="''${arr[1]}"
          arr=("''${arr[@]:2}")

          kill -0 "$pid" 2>/dev/null || continue

          mem=$(ps -p "$pid" -o rss= | awk '{print $1/1024}')
          total=$(echo "$mem"+"$total" | bc)
          name=$(ps -p "$pid" -o comm=)

          printf "%''${space}s%s($pid): $mem MB\n" "$name"

          mapfile -t children < <(pgrep -P "$pid")

          for child in "''${children[@]}"; do
            arr+=("$child" $((space+2)))
          done
        done
      }

      p=$1

      if [[ -z $p ]]; then
        p=$(ps -eo pid,user,comm | tail -n +2 | fzf | awk '{print $1}')
      fi

      while true; do
        print_vmrss "$p"
        sleep 0.5
      done
    '';
  };
}
