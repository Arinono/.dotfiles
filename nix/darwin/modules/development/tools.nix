{
  pkgs,
  ...
}: {
  # Development tools
  environment.systemPackages = with pkgs; [
    # Languages
    go
    rustc
    cargo
    nodejs
    
    # Dev tools
    bat
    eza
    dust
    just
    alejandra  # Nix formatter
    direnv
    
    # Build tools
    sccache
  ];
}