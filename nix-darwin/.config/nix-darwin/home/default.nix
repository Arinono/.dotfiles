{
  config,
  pkgs,
  lib,
  username,
  fullname,
  email,
  home,
  isDarwin,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit username email fullname isDarwin home;
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
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${home}/.dotfiles/nvim/.config/nvim";
}
