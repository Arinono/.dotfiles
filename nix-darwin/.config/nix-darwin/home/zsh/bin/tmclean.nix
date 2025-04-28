{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "tmclean";
    runtimeInputs = [pkgs.toybox];

    text = ''
      list=$(tmutil listlocalsnapshotdates | tail -n +2 | tr '\n' ' ' | sed 's/ $//')

      for s in $list; do
        tmutil deletelocalsnapshots "$s"
      done
    '';
  };
}
