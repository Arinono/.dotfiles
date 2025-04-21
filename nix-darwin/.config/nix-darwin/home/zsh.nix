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

  git-contrib = pkgs.writeShellApplication {
    name = "git-contrib";
    runtimeInputs = [pkgs.git];

    text = ''
      git shortlog -sne --all
    '';
  };

  key = pkgs.writeShellApplication {
    name = "key";
    runtimeInputs = [pkgs.tinyxxd];

    text = ''
      set +o nounset
      len=$1

      if [[ -z $len ]]; then
        len=32
      fi

      head -c "$len" /dev/urandom | tinyxxd -p -c "$len"
    '';
  };
in {
  programs = {
    zsh = {
      enable = true;

      sessionVariables = {
        EDITOR = editor;
        VISUAL = editor;
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
      key
      git-contrib
    ];
  };

  # home.file = {
  #   ".zshrc".source = mkOutOfStoreSymlink "/Users/${username}/.dotfiles/zsh/.zshrc";
  #   ".zsh_profile".source = mkOutOfStoreSymlink "/Users/${username}/.dotfiles/zsh/.zsh_profile";
  # };
}
