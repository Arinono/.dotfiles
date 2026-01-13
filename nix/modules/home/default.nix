{
  config,
  pkgs,
  lib,
  isDarwin,
  params,
  secrets,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit params secrets;
  username = params.username;
  home = params.home;
in {
  programs.home-manager = {
    enable = true;
  };

  home = {
    inherit username;
    homeDirectory = home;
    preferXdgDirectories = true;

    stateVersion = "24.11";
  };

  imports = [
    ./modules/zsh
    ./modules/gitconfig.nix
    # ./modules/carapace.nix
    ./modules/bat.nix
    ./modules/ctop.nix
    ./modules/btop.nix
    ./modules/gh-dash.nix
    ./modules/tealdeer.nix
    ./modules/tmux.nix
    # ./modules/wezterm.nix
    ./modules/zoxide.nix
    ./modules/ssh-import.nix
    ./modules/gpg-import.nix
  ];

  home.file = {
    stow-ignore = {
      target = ".stow-global-ignore";
      text = ''
        Dockerfile.*
        docker-compose.*
      '';
    };

    npmrc = {
      target = ".npmrc";
      text = secrets.npm.rc;
    };
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;
  xdg.configFile = {
    nvim.source = mkOutOfStoreSymlink "${home}/.dotfiles/nvim";
  };
}
