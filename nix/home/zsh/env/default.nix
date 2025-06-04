{
  editor,
  isDarwin,
  pkgs,
  home,
  ...
}: let
  browser =
    if isDarwin
    then "arc"
    else "brave";
in {
  aliases = {
    eza = "${pkgs.eza}/bin/eza  -l --git --group-directories-first";
    ls = "eza";
    ll = "eza";
    la = "eza -a";
    vim = "nvim";
    v = "nvim";
  };

  variables = {
    EDITOR = editor;
    VISUAL = editor;
    TERM = "xterm-256color";
    LC_ALL = "en_US.UTF-8";
    BROWSER = browser;
    WORKSPACE = "${home}/workspace";
  };
}
