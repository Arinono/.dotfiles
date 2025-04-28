{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "update_all_crates";
    runtimeInputs = [pkgs.sccache pkgs.cargo pkgs.toybox pkgs.ripgrep];

    text = ''
      for pkg in $(cargo install --list | rg ':' | awk '{print $1}'); do
        RUSTC_WRAPPER=sccache cargo install "$pkg"
      done
    '';
  };
}
