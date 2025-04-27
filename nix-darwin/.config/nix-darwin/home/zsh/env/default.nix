{editor, ...}: {
  aliases = {
    eza = "eza -l --git --group-directories-first";
    ls = "eza";
    ll = "eza";
    la = "exa -a";
    vim = "nvim";
    v = "nvim";
  };

  variables = {
    EDITOR = editor;
    VISUAL = editor;
    TERM = "xterm-256color";
    LC_ALL = "en_US.UTF-8";
    BROWSER = "arc";
  };
}
