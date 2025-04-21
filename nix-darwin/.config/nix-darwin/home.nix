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
  programs.zsh.enable = true;

  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";
  };

  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/${username}/.dotfiles/nvim/.config/nvim";
}
