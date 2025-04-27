{
  config,
  pkgs,
  lib,
  username,
  fullname,
  email,
  isDarwin,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit username email fullname isDarwin;
in {
  programs.home-manager.enable = true;
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    preferXdgDirectories = true;

    stateVersion = "24.11";
  };

  imports = [
    ./zsh
    ./gitconfig.nix
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/${username}/.dotfiles/nvim/.config/nvim";
}
