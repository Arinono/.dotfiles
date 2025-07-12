{
  inputs,
  pkgs,
  params,
  ...
}: let
  proton-vpn = pkgs.callPackage ../darwin/modules/proton-vpn.nix {};
in rec {
  base = with pkgs; [
    alejandra
    bat
    bc
    btop
    curl
    dig
    direnv
    dua
    dust
    eza
    fd
    ffmpeg
    fzf
    gcc
    gh
    gh-dash
    git
    git-crypt
    glow
    htop
    jq
    just
    mdbook
    neovim
    nil
    openssl
    parallel
    ripgrep
    rsync
    sccache
    timer
    tmux
    tree
    wget
  ];

  dev = with pkgs; [
    cargo
    cargo-generate
    cargo-info
    cargo-modules
    dart
    go
    golangci-lint
    gopls
    hexedit
    hexyl
    minio
    minio-client
    ngrok
    nodejs
    oha
    pnpm
    rustc
    rustfmt
    inputs.simple_http_server.packages.${pkgs.system}.default
    sqld
    tokei
    trunk
    turso-cli
    vhs
    wasm-pack
    websocat
  ];

  shared = with pkgs; [
    obsidian
    spotify
    brave
  ];

  darwin = with pkgs;
    [
      ollama
      flyctl
      keycastr
      terminal-notifier
      utm
      docker
      proton-vpn
      tailscale

      arc-browser
    ]
    ++ shared;

  linux = with pkgs;
    [
      calibre
      discord
      nerd-fonts.meslo-lg
      vlc
      inputs.zen-browser.packages."${params.system}".default
      proton-pass
    ]
    ++ shared;
}
