{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
            pkgs.asciinema
            pkgs.btop
            pkgs.bun
            pkgs.curl
            pkgs.direnv
            pkgs.ffmpeg
            pkgs.flyctl
            pkgs.gh
            pkgs.glow
            pkgs.hexedit
            pkgs.htop
            pkgs.iperf
            pkgs.jq
            pkgs.minio
            pkgs.minio-client
            pkgs.neofetch
            pkgs.neovim
            pkgs.rsync
            pkgs.terminal-notifier
            pkgs.timer
            pkgs.tmux
            pkgs.tree
            pkgs.vhs
            pkgs.vim
            pkgs.wget

            pkgs.bat
            pkgs.cargo-generate
            pkgs.cargo-info
            pkgs.cargo-modules
            pkgs.dua
            pkgs.dust
            pkgs.eza
            pkgs.fd
            pkgs.hexyl
            pkgs.just
            pkgs.mdbook
            pkgs.oha
            pkgs.ripgrep
            pkgs.sccache
            pkgs.sshx
            pkgs.tealdeer
            pkgs.tokei
            pkgs.trunk
            pkgs.wasm-pack
            pkgs.websocat
            pkgs.zoxide

        ];

      homebrew.enable = true;
      homebrew.taps = [
          "libsql/sqld"
          "tursodatabase/tap"
          "twitchdev/twitch"
          "nikitabobko/tap"
          "felixkratz/formulae"
      ];
      homebrew.casks = [
          "ngrok"
          "shottr"
          # "docker"
          "aerospace"
      ];
      homebrew.brews = [
          "sqld"
          "turso"
          "twitch-cli"
          "sketchybar"
      ];

      # Auto upgrade nix package and the daemon service.
      nix = {
        enable = true;
        package = pkgs.nix;

        # Necessary for using flakes on this system.
        settings.experimental-features = "nix-command flakes";
        settings.trusted-users = ["arinono" "@admin"];
        settings.max-jobs = "auto";
        settings.builders-use-substitutes = true;
        settings.builders = [
            "aatrox aarch64-linux /var/root/.ssh/remotebuild 4 1 ; ahri x86_64-linux /var/root/.ssh/remotebuild 4 1"
        ];

        linux-builder = {
          enable = true;

          ephemeral = true;
          maxJobs = 4;
          config = {
            virtualisation = {
              darwin-builder = {
                diskSize = 40 * 1024;
                memorySize = 8 * 1024;
              };
              cores = 6;
            };
          };
        };
      };


      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;
      ids.gids.nixbld = 30000;


      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#lux
    darwinConfigurations."lux" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."lux".pkgs;
  };
}
