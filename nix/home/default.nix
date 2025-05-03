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
    # backupFileExtension = "backup";
  };

  home = {
    inherit username;
    homeDirectory = home;
    preferXdgDirectories = true;

    stateVersion = "24.11";
  };

  imports = [
    ./zsh
    ./gitconfig.nix
    ./aerospace.nix
    # ./carapace.nix
    ./ctop.nix
    ./btop.nix
    ./fonts.nix
    ./gh-dash.nix
    ./ghostty.nix
    ./tealdeer.nix
    ./tmux.nix
    ./wezterm.nix
    ./zoxide.nix
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

    sshconfig = {
      target = ".ssh/config";
      text = secrets.ssh.config;
    };
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${home}/.dotfiles/nvim";
  xdg.configFile.sketchybar.source = mkOutOfStoreSymlink "${home}/.dotfiles/sketchybar";
}
