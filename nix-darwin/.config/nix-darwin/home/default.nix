{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit username;
in {
  programs.home-manager.enable = true;
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";
  };

  imports = [
    ./zsh.nix
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/${username}/.dotfiles/nvim/.config/nvim";
}
