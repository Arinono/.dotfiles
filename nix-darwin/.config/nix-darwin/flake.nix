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
      nixpkgs.config.allowUnfree = true;

      users.users.arinono = {
        name = username;
        home = "/Users/${username}";
      };

      environment.systemPackages = [
        pkgs.aerospace
        pkgs.keycastr

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
        pkgs.ngrok
        pkgs.rsync
        pkgs.sqld
        pkgs.terminal-notifier
        pkgs.timer
        pkgs.tmux
        pkgs.tree
        pkgs.turso-cli
        pkgs.vhs
        pkgs.wget

        pkgs.arc-browser
        pkgs.brave
        # pkgs.ghostty - Broken on darwin
        pkgs.obsidian
        pkgs.spotify
        # pkgs.vlc - Not on aarch64-darwin

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
        pkgs.tealdeer
        pkgs.tokei
        pkgs.trunk
        pkgs.wasm-pack
        pkgs.websocat
        pkgs.zoxide
      ];

      homebrew = {
        enable = true;

        taps = [];

        casks = [
          "ghostty"
          "alfred"
          "balenaetcher"
          "discord"
          "docker"
          "font-meslo-lg-nerd-font"
          "istat-menus"
          "scroll-reverser"
          "shottr"
          "signal"
          "vlc"
        ];

        brews = [];

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

      system.defaults = {
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleShowAllExtensions = true;
          AppleTemperatureUnit = "Celsius";
          InitialKeyRepeat = 20;
          KeyRepeat = 2;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSTableViewDefaultSizeMode = 2;
          NSWindowShouldDragOnGesture = true;
          _HIHideMenuBar = true;
          "com.apple.sound.beep.feedback" = 0;
          "com.apple.sound.beep.volume" = 0.40;
          "com.apple.springing.delay" = 0.5;
          "com.apple.springing.enabled" = true;
          "com.apple.swipescrolldirection" = true;
          "com.apple.trackpad.forceClick" = true;
          "com.apple.trackpad.scaling" = 0.6875;
        };
        loginwindow = {
          GuestEnabled = false;
        };
        finder = {
          AppleShowAllFiles = true;
          AppleShowAllExtensions = true;
          FXDefaultSearchScope = "SCcf";
          FXPreferredViewStyle = "clmv";
          NewWindowTarget = "Other";
          NewWindowTargetPath = "file:///Users/${username}/Downloads";
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = false;
          _FXShowPosixPathInTitle = true;
        };
        trackpad = {
          ActuationStrength = 1;
          Clicking = false;
          Dragging = false;
          FirstClickThreshold = 1;
        };
        dock = {
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.25;
          expose-animation-duration = 0.0;
          expose-group-apps = true;
          orientation = "right";
          mineffect = "scale";
          launchanim = false;
          tilesize = 32;
          magnification = false;
          minimize-to-application = true;
          mru-spaces = false;
          persistent-apps = [
            {
              app = "/Applications/Ghostty.app";
            }
            {
              app = "${pkgs.spotify}/Applications/Spotify.app";
            }
            {
              app = "${pkgs.arc-browser}/Applications/Arc.app";
            }
          ];
          persistent-others = [
            "/Users/${username}/Downloads"
          ];
          show-recents = false;
          showhidden = true;
          slow-motion-allowed = false;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };
        CustomSystemPreferences = {
          NSGlobalDomain = {
            AppleLanguages = ["en-FR"];
            AppleLocale = "en_FR";
            AppleReduceDesktopTinting = true;
            AppleShowScrollBars = "Automatic";
            NSAutomaticTextCompletionEnabled = true;
            NSNavPanelFileLastListModeForOpenModeKey = 2;
            NSNavPanelFileListModeForOpenMode2 = 1;
            "com.apple.sound.beep.flash" = 0;
            "com.apple.sound.uiaudio.enabled" = 1;
            CGDisableCursorLocationMagnification = 1;
          };
          finder = {
            DisableAllAnimations = true;
            FK_ArrangeBy = "Date Added";
            FK_SidebarWidth = 150;
            FXArrangeGroupViewBy = "Name";
            FXLastSearchScope = "SCcf";
            FXPreferredGroupBy = "Name";
            FXPreferredSearchViewStyle = "Nlsv";
            RecentsArrangeGroupViewBy = "Date Last Opened";
            ShowSidebar = true;
            SidebarDevicesSectionDisclosedState = true;
            SidebarPlacesSectionDisclosedState = true;
            SidebarShowingSignedIntoiCloud = true;
            SidebarTagsSectionDisclosedState = false;
            SidebariCloudDriveSectionDisclosedState = true;
          };
        };
      };

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
