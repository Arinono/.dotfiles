{
  isDarwin,
  lib,
  ...
}: let
  enable =
    if isDarwin
    then false
    else true;
in {
  # Shitty workaround for ghostty not working on darwin yet through nix
  ${
    if isDarwin
    then "xdg"
    else "programs"
  } =
    if isDarwin
    then {
      configFile.ghostty = {
        target = "ghostty/config";
        text = ''
          title = Ghostty
          font-family = Dank Mono
          font-thicken = true
          cursor-color = ffffff
          font-size = 14
          window-decoration = false
          theme = tokyonight-storm
          auto-update = download
          confirm-close-surface = false
        '';
      };
    }
    else {
      ghostty = {
        inherit enable;

        enableZshIntegration = true;

        settings = {
          title = "Ghostty";
          font-family = "Dank Mono";
          font-thicken = true;
          cursor-color = "ffffff";
          font-size = 14;
          window-decoration = false;
          theme = "tokyonight-storm";
          auto-update = "download";
          confirm-close-surface = false;
        };
      };
    };
}
