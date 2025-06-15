{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "git_contrib";
    runtimeInputs = [pkgs.git];

    text = ''
      git shortlog -sne --all
    '';
  };
}
