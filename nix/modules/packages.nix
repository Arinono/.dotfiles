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
    minio-client
    ngrok
    nodejs
    oha
    opencode
    pnpm
    rustc
    rustfmt
    inputs.simple_http_server.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    localsend
  ];

  darwin = with pkgs;
    [
      docker
      # istat-menus Could not download from mirror
      keycastr
      proton-vpn
      raycast
      scroll-reverser
      secretive
      shottr
      tailscale
      terminal-notifier
      inputs.zen-browser.packages."${params.system}".default
    ]
    ++ shared;

  linux = with pkgs;
    [
      busybox
      discord
      gparted
      nerd-fonts.meslo-lg
      vlc
      inputs.zen-browser.packages."${params.system}".default
      proton-pass
    ]
    ++ shared;
}
