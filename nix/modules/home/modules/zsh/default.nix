{
  pkgs,
  isDarwin,
  username,
  params,
  secrets,
  ...
}: let
  editor = "nvim";
  home = params.home;

  # Envs
  default = import ./env {inherit editor pkgs isDarwin home;};
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
  git_contrib = import ./bin/git_contrib.nix {inherit pkgs;};
  key = import ./bin/key.nix {inherit pkgs;};
  ngrokd = import ./bin/ngrokd.nix {inherit pkgs;};
  remind = import ./bin/remind.nix {inherit pkgs;};
  portscan = import ./bin/portscan.nix {inherit pkgs;};
  dummy_file = import ./bin/dummy_file.nix {inherit pkgs;};
  vmrss = import ./bin/vmrss.nix {inherit pkgs;};
  ntfy = import ./bin/ntfy.nix {inherit pkgs;};
  convert = import ./bin/convert.nix {inherit pkgs;};
  tmclean = import ./bin/tmclean.nix {inherit pkgs;};
  update_all_crates = import ./bin/update_all_crates.nix {inherit pkgs;};

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
      autosuggestion = {
        enable = true;
        highlight = "fg=#737993";
      };
      syntaxHighlighting.enable = true;

      history = {
        save = 100000;
        size = 100000;
        expireDuplicatesFirst = true;
      };

      envExtra = ''
        export GPG_TTY=$(tty)
      '';

      sessionVariables =
        default.variables
        // ngrok.variables
        // cargo.variables
        // direnv.variables
        // go.variables
        // tmux.variables
        // secrets.wtg.variables;

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
      enableBashIntegration = false;

      settings = {
        add_newline = false;
        aws.disabled = true;

        nix_shell = {
          disabled = false;
          impure_msg = "";
          format = "[$symbol$state]($style) ";
        };
      };
    };
  };

  home = let
    darwinPackages = [
      remind.sh
    ];
  in {
    sessionPath =
      [
        "${home}/.local/bin"
      ]
      ++ cargo.path
      ++ android_studio.path
      ++ dart.path
      ++ node.path;

    packages =
      [
        nsh
        key.sh
        git_contrib.sh
        ngrokd.sh
        portscan.sh
        dummy_file.sh
        vmrss.sh
        ntfy.sh
        convert.sh
        tmclean.sh
        update_all_crates.sh
        docker.denter
        git.gsync
        git.git_current_branch
        git.git_branch_main
        tmux.kill_session
        tmux.tmux_sessionizer
        tmux.tmux_worktree_panizer
      ]
      ++ (
        if isDarwin
        then darwinPackages
        else []
      );
  };
}
