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
  programs.home-manager.enable = true;
  home = {
    inherit username;
    homeDirectory = home;
    preferXdgDirectories = true;

    stateVersion = "24.11";
  };

  imports = [
    ./zsh
    ./gitconfig.nix
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${home}/.dotfiles/nvim/.config/nvim";
}
