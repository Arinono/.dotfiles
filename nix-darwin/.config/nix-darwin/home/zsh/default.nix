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

  # Envs
  default = import ./env {inherit editor;};
  ngrok = import ./env/ngrok.nix {};
  cargo = import ./env/cargo.nix {inherit pkgs;};
  android_studio = import ./env/android_studio.nix {inherit username;};
  dart = import ./env/dart.nix {inherit username pkgs;};
  direnv = import ./env/direnv.nix {};
  docker = import ./env/docker.nix {inherit pkgs;};
  git = import ./env/git.nix {inherit pkgs;};

  # Scripts
  git_contrib = import ../bin/git_contrib.nix {inherit pkgs;};
  key = import ../bin/key.nix {inherit pkgs;};
  ngrokd = import ../bin/ngrokd.nix {inherit pkgs;};
  remind = import ../bin/remind.nix {inherit pkgs;};
  portscan = import ../bin/portscan.nix {inherit pkgs;};
  dummy_file = import ../bin/dummy_file.nix {inherit pkgs;};
  vmrss = import ../bin/vmrss.nix {inherit pkgs;};
in {
  programs = {
    zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        save = 100000;
        size = 100000;
        expireDuplicatesFirst = true;
      };

      sessionVariables = default.variables // ngrok.variables // cargo.variables // direnv.variables;

      shellAliases = default.aliases // docker.aliases // git.aliases;
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
    sessionPath =
      [
        "/Users/${username}/.local/bin"
      ]
      ++ cargo.path ++ android_studio.path ++ dart.path;

    packages = [
      key.sh
      git_contrib.sh
      ngrokd.sh
      remind.sh
      portscan.sh
      dummy_file.sh
      vmrss.sh
      docker.denter
      git.gsync
      git.git_current_branch
    ];
  };
}
