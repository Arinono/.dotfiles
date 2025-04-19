{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
  }: let
    systems = ["aarch64-darwin" "x86_64-linux"];
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "arinono";

    installBrew = with pkgs;
      pkgs.writeShellApplication {
        name = "install-homebrew";
        runtimeInputs = [bash curl];

        text = ''
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        '';
      };

    configuration = {
      pkgs,
      lib,
      config,
      ...
    }: {
      users.users.arinono = {
        name = username;
        home = "/Users/${username}";
      };

      environment.systemPackages = [
        pkgs.alejandra
        pkgs.btop
        pkgs.curl
        pkgs.direnv
        pkgs.ffmpeg
        pkgs.flyctl
        pkgs.gh
        pkgs.glow
        pkgs.hexedit
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

      homebrew = {
        enable = true;

        taps = [
          "libsql/sqld"
          "tursodatabase/tap"
          "twitchdev/twitch"
          "nikitabobko/tap"
          "felixkratz/formulae"
        ];

        casks = [
          "ngrok"
          "shottr"
          # "docker"
          #"aerospace"
        ];

        brews = ["sqld" "turso" "twitch-cli" "sketchybar"];

        masApps = {
          # Tailscale = 1475387142;
          # Wireguard = 1451685025;
        };
      };

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
		echo "setting up /Applications..." >&2
		rm -rf /Applications/Nix\ Apps
		mkdir -p /Applications/Nix\ Apps
		find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
		while read -r src; do
			app_name=$(basename "$src")
			echo "copying $src" >&2
			${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
		done
        '';

      nix = {
        enable = true;
        package = pkgs.nix;

        settings.experimental-features = "nix-command flakes";
        settings.trusted-users = ["arinono" "@admin"];
        settings.max-jobs = "auto";
        settings.builders-use-substitutes = true;

        # settings.builders = [
        #   "aatrox aarch64-linux /var/root/.ssh/remotebuild 4 1 ; ahri x86_64-linux /var/root/.ssh/remotebuild 4 1"
        # ];

        # buildMachines = [
        #   {
        #     hostName = "aatrox";
        #     systems = ["aarch64-linux"];
        #     sshKey = "/var/root/.ssh/remotebuild";
        #     maxJobs = 4;
        #     speedFactor = 1;
        #   }
        #   {
        #     hostName = "ahri";
        #     systems = ["x86_64-linux"];
        #     sshKey = "/var/root/.ssh/remotebuild";
        #     maxJobs = 4;
        #     speedFactor = 1;
        #   }
        #   {
        #     hostName = "localhost";
        #     systems = ["aarch64-darwin"];
        #     maxJobs = 4;
        #     speedFactor = 1;
        #   }
        # ];

        # linux-builder = {
        #   package = nixpkgs-stable.legacyPackages.aarch64-darwin.darwin.linux-builder;
        #   enable = true;
        #
        #   ephemeral = true;
        #   maxJobs = 4;
        #   config = {
        #     virtualisation = {
        #       darwin-builder = {
        #         diskSize = 40 * 1024;
        #         memorySize = 8 * 1024;
        #       };
        #       cores = 6;
        #     };
        #   };
        # };
      };

      programs.zsh.enable = true;

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 5;
      # ids.gids.nixbld = 30000;

      nixpkgs.hostPlatform = system;
    };

    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});
  in {
    darwinConfigurations."lux" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.users.arinono = import ./home.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."lux".pkgs;

    packages.aarch64-darwin.installBrew = installBrew;

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
  };
}
