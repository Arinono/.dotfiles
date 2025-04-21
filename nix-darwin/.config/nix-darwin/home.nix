{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  programs.zsh.enable = true;

  programs.home-manager.enable = true;

  home = {
    username = "arinono";
    homeDirectory = "/Users/arinono";
    stateVersion = "24.11";
  };

  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/arinono/.dotfiles/nvim/.config/nvim";
}
