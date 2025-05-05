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
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    git_worktree_clean,
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
      legacyBld = true;
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

    setHostname = {hostname}:
      pkgs.writeShellApplication {
        name = "set-hostname";

        text = ''
          sudo scutil --set HostName ${hostname}
          sudo scutil --set LocalHostName ${hostname}
          sudo scutil --set ComputerName ${hostname}
          dscacheutil -flushcache
        '';
      };

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
      ];

      environment.systemPackages = with pkgs; [
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
        inputs.git_worktree_clean.packages.${pkgs.system}.default
        glow
        gnupg
        go
        hexedit
        hexyl
        htop
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
        pinentry-tty
        ripgrep
        rsync
        rustc
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
      ];

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
          "crystalfetch"
          "discord"
          "docker"
          "font-meslo-lg-nerd-font"
          "flycut"
          "ghostty"
          "istat-menus"
          "scroll-reverser"
          "shottr"
          "signal"
          "soundsource"
          "vlc"
        ];

        brews = [];

        masApps = {
          Tailscale = 1475387142;
          Wireguard = 1451685025;
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
        general
        // global
        // dock_finder
        // shottr
        // istat_menus
        // flycut
        // scroll_reverser
        // soundsource
        // arc_browser
        // keycastr
        // tailscale
        // vlc;

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

      ids.gids.nixbld =
        if params.legacyBld
        then 30000
        else 350;

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
    packages.aarch64-darwin.setHostname = setHostname {
      hostname = params.hostname;
    };

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
  };
}
