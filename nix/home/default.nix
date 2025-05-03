{
  config,
  pkgs,
  lib,
  username,
  fullname,
  email,
  home,
  isDarwin,
  wtg,
  personal,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit username email fullname isDarwin home wtg;
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

  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
  };

  imports = [
    ./zsh
    ./gitconfig.nix
    ./aerospace.nix
    ./ctop.nix
    ./btop.nix
    ./fonts.nix
    ./gh-dash.nix
    ./ghostty.nix
    ./tmux.nix
    ./wezterm.nix
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
      text = personal.npm.rc;
    };

    sshconfig = {
      target = ".ssh/config";
      text = personal.ssh.config;
    };
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${home}/.dotfiles/nvim/.config/nvim";
}
