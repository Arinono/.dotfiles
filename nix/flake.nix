{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    git_worktree_clean = {
      url = "path:../git_worktree_clean";
      flake = true;
    };

    private_flakes = {
      url = "git+ssh://git@github.com/arinono/private-flakes.git";
      flake = true;
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    git_worktree_clean,
    private_flakes,
  }: let
    systems = ["aarch64-darwin" "x86_64-linux"];
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    # move to fn param later
    params = rec {
      username = "arinono";
      hostname = "lux";
      home = "/Users/${username}";
      fullname = "Aurelien Arino";
      email = "dev@arino.io";
    };

    secrets = import ./secrets {inherit params;};

    defaults = {
      general = import ./darwin/defaults/general.nix {inherit params;};
      global = import ./darwin/defaults/global.nix {};
      dock_finder = import ./darwin/defaults/dock_finder.nix {inherit pkgs params;};
      shottr = import ./darwin/defaults/shottr.nix {inherit params secrets;};
      istat_menus = import ./darwin/defaults/istat_menus.nix {inherit secrets;};
      flycut = import ./darwin/defaults/flycut.nix {};
      scroll_reverser = import ./darwin/defaults/scroll_reverser.nix {};
      soundsource = import ./darwin/defaults/soundsource.nix {inherit secrets;};
      arc_browser = import ./darwin/defaults/arc_browser.nix {};
      keycastr = import ./darwin/defaults/keycastr.nix {};
      tailscale = import ./darwin/defaults/tailscale.nix {};
      vlc = import ./darwin/defaults/vlc.nix {};
    };

    installBrew = with pkgs;
      pkgs.writeShellApplication {
        name = "install-homebrew";
        runtimeInputs = [bash curl];

        text = ''
          bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        '';
      };

    setHostname = pkgs.writeShellApplication {
      name = "set-hostname";

      text = ''
        HOSTNAME=''${1:-$HOSTNAME}
        if [ -z "$HOSTNAME" ]; then
          echo "Error: No hostname provided"
          echo "Usage: nix run .#setHostname -- <hostname> or HOSTNAME=<value> nix run .#setHostname"
          exit 1
        fi

        sudo scutil --set HostName "$HOSTNAME"
        sudo scutil --set LocalHostName "$HOSTNAME"
        sudo scutil --set ComputerName "$HOSTNAME"
        dscacheutil -flushcache
      '';
    };

    fonts = import ./darwin/modules/fonts.nix {
      inherit pkgs;
      username = params.username;
    };
    firewall = import ./darwin/modules/firewall.nix {};

    proton-vpn = pkgs.callPackage ./darwin/modules/proton-vpn.nix {};

    configuration = {
      pkgs,
      lib,
      config,
      ...
    }: {
      nixpkgs.config.allowUnfree = true;

      users.users.arinono = {
        home = params.home;
        name = params.username;
      };

      imports = [
        ./darwin/services/aerospace.nix
        ./darwin/services/sketchybar.nix

        fonts
        firewall
      ];

      environment.systemPackages = with pkgs;
        [
          alejandra
          bat
          btop
          cargo
          cargo-generate
          cargo-info
          cargo-modules
          curl
          dart
          devbox
          direnv
          dua
          dust
          eza
          fd
          ffmpeg
          flyctl
          fzf
          gh
          git
          git-crypt
          glow
          go
          golangci-lint
          gopls
          hexedit
          hexyl
          htop
          inputs.git_worktree_clean.packages.${pkgs.system}.default
          iperf
          jq
          just
          keycastr
          mdbook
          minio
          minio-client
          neofetch
          neovim
          ngrok
          nil
          nodejs
          oha
          parallel
          pnpm
          proton-vpn
          ripgrep
          rsync
          rustc
          rustfmt
          sccache
          sqld
          tailscale
          terminal-notifier
          timer
          tmux
          tokei
          tree
          trunk
          turso-cli
          utm
          vhs
          wasm-pack
          websocat
          wget

          arc-browser
          brave
          # ghostty - Broken on darwin
          obsidian
          spotify
          # vlc - Not on aarch64-darwin
        ]
        ++ private_flakes.bins system;

      homebrew = {
        enable = true;

        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };

        taps = [];

        casks = [
          "alfred"
          "balenaetcher"
          "calibre"
          "cameracontroller"
          "crystalfetch"
          "discord"
          "docker"
          "flycut"
          "font-meslo-lg-nerd-font"
          "ghostty"
          "istat-menus"
          "scroll-reverser"
          "shottr"
          "signal"
          "soundsource"
          "visual-studio-code@insiders"
          "vlc"
        ];

        brews = [];

        masApps = {
          Tailscale = 1475387142;
          Wireguard = 1451685025;
          Numbers = 409203825;
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

      system.defaults = with defaults;
        {
          CustomSystemPreferences = with defaults;
            general.CustomSystemPreferences
            // global.CustomSystemPreferences
            // dock_finder.CustomSystemPreferences;

          CustomUserPreferences = with defaults;
            arc_browser.CustomUserPreferences
            // flycut.CustomUserPreferences
            // istat_menus.CustomUserPreferences
            // keycastr.CustomUserPreferences
            // scroll_reverser.CustomUserPreferences
            // shottr.CustomUserPreferences
            // soundsource.CustomUserPreferences
            // tailscale.CustomUserPreferences
            // vlc.CustomUserPreferences;
        }
        // general.base
        // global.base
        // dock_finder.base;

      nix = {
        enable = true;
        package = pkgs.nix;

        settings.experimental-features = "nix-command flakes";
        settings.trusted-users = ["arinono" "@admin"];
        settings.max-jobs = "auto";
        settings.builders-use-substitutes = true;

        settings.builders = lib.mkForce [
          "aatrox aarch64-linux /var/root/.ssh/remotebuild 4 1 ; ahri x86_64-linux /var/root/.ssh/remotebuild 4 1"
        ];

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

      ids.gids.nixbld = 350;

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 5;

      nixpkgs.hostPlatform = system;
    };

    isDarwin = true;
    homeManagerArgs = {
      # NOTE: change isDarwin to use provided function value when setting
      # up the machines
      inherit isDarwin params secrets;
    };

    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});
  in {
    darwinConfigurations."${params.hostname}" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${params.username} = import ./home;
            extraSpecialArgs = homeManagerArgs;
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."${params.hostname}".pkgs;

    packages.aarch64-darwin.installBrew = installBrew;
    packages.aarch64-darwin.setHostname = setHostname;

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
  };
}
