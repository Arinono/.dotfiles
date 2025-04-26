{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit username;
  editor = "nvim";

  git_contrib = import ./bin/git_contrib.nix {inherit pkgs;};
  key = import ./bin/key.nix {inherit pkgs;};
  ngrokd = import ./bin/ngrokd.nix {inherit pkgs;};
  remind = import ./bin/remind.nix {inherit pkgs;};
  portscan = import ./bin/portscan.nix {inherit pkgs;};
  dummy_file = import ./bin/dummy_file.nix {inherit pkgs;};
  vmrss = import ./bin/vmrss.nix {inherit pkgs;};
in {
  programs = {
    zsh = {
      enable = true;

      sessionVariables = {
        EDITOR = editor;
        VISUAL = editor;
        NGROK_DOMAIN = "alive-ant-pure.ngrok-free.app";
        TERM = "xterm-256color";
      };

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = false;
        aws.disabled = true;
      };
    };
  };

  home = {
    packages = [
      key.sh
      git_contrib.sh
      ngrokd.sh
      remind.sh
      portscan.sh
      dummy_file.sh
      vmrss.sh
    ];
  };
}
