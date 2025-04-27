{
  config,
  pkgs,
  lib,
  username,
  home,
  isDarwin,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  editor = "nvim";

  # Envs
  default = import ./env {inherit editor;};
  ngrok = import ./env/ngrok.nix {};
  cargo = import ./env/cargo.nix {inherit pkgs home;};
  android_studio = import ./env/android_studio.nix {inherit home;};
  dart = import ./env/dart.nix {inherit home pkgs;};
  direnv = import ./env/direnv.nix {};
  docker = import ./env/docker.nix {inherit pkgs;};
  git = import ./env/git.nix {inherit pkgs;};
  go = import ./env/go.nix {inherit home;};
  node = import ./env/node.nix {inherit pkgs home;};
  tailscale = import ./env/tailscale.nix {inherit home isDarwin;};
  tmux = import ./env/tmux.nix {inherit pkgs home;};

  # Scripts
  git_contrib = import ../bin/git_contrib.nix {inherit pkgs;};
  key = import ../bin/key.nix {inherit pkgs;};
  ngrokd = import ../bin/ngrokd.nix {inherit pkgs;};
  remind = import ../bin/remind.nix {inherit pkgs;};
  portscan = import ../bin/portscan.nix {inherit pkgs;};
  dummy_file = import ../bin/dummy_file.nix {inherit pkgs;};
  vmrss = import ../bin/vmrss.nix {inherit pkgs;};
  ntfy = import ../bin/ntfy.nix {inherit pkgs;};
  convert = import ../bin/convert.nix {inherit pkgs;};

  nsh = pkgs.writeShellApplication {
    name = "nsh";
    runtimeInputs = [];

    text = ''
      if [[ -z "$1" ]]; then
        echo "Usage: nsh <nix-package>"
        return 1
      fi

      nix shell "nixpkgs#$1"
    '';
  };
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

      sessionVariables =
        default.variables
        // ngrok.variables
        // cargo.variables
        // direnv.variables
        // go.variables
        // tmux.variables;

      shellAliases =
        default.aliases
        // docker.aliases
        // git.aliases
        // node.aliases
        // tailscale.aliases
        // tmux.aliases;
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
        "${home}/.local/bin"
      ]
      ++ cargo.path
      ++ android_studio.path
      ++ dart.path
      ++ node.path;

    packages = [
      nsh
      key.sh
      git_contrib.sh
      ngrokd.sh
      remind.sh
      portscan.sh
      dummy_file.sh
      vmrss.sh
      ntfy.sh
      convert.sh
      docker.denter
      git.gsync
      git.git_current_branch
    ];
  };
}
