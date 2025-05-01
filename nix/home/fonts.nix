{isDarwin, ...}: let
  target =
    if isDarwin
    then "Library/Fonts"
    else ".local/share/fonts";
in {
  home.file = {
    "${target}" = {
      source = ../../../../fonts;
      recursive = true;
    };
  };
}
