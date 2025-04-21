{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
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

    # move to fn param later
    username = "arinono";
    hostname = "lulu";

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
        name = username;
        home = "/Users/${username}";
      };

      environment.systemPackages = with pkgs; [
        aerospace
        keycastr

        alejandra
        btop
        cargo
        curl
        direnv
        ffmpeg
        flyctl
        fzf
        gh
        glow
        go
        hexedit
        iperf
        jq
        minio
        minio-client
        neofetch
        neovim
        ngrok
        nil
        nodejs
        rsync
        rustc
        sqld
        terminal-notifier
        timer
        tmux
        tree
        turso-cli
        vhs
        wget

        arc-browser
        brave
        # ghostty - Broken on darwin
        obsidian
        spotify
        # vlc - Not on aarch64-darwin

        bat
        cargo-generate
        cargo-info
        cargo-modules
        dua
        dust
        eza
        fd
        hexyl
        just
        mdbook
        oha
        ripgrep
        sccache
        tealdeer
        tokei
        trunk
        wasm-pack
        websocat
        zoxide
      ];

      homebrew = {
        enable = true;

        taps = [];

        casks = [
          "ghostty"
          "alfred"
          "balenaetcher"
          "calibre"
          "crystalfetch"
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
        hitoolbox = {
          AppleFnUsageType = "Do Nothing";
        };

        menuExtraClock = {
          FlashDateSeparators = false;
          IsAnalog = false;
          Show24Hour = true;
          ShowAMPM = false;
          ShowDate = 0;
          ShowDayOfMonth = true;
          ShowDayOfWeek = true;
          ShowSeconds = false;
        };

        screencapture = {
          disable-shadow = true;
          include-date = true;
          location = "/Users/${username}/Downloads";
          show-thumbnail = true;
          target = "file";
          type = "jpg";
        };

        screensaver = {
          askForPassword = true;
          askForPasswordDelay = 0;
        };

        smb = {
          NetBIOSName = hostname;
        };

        spaces.spans-displays = false;

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
          "com.apple.airplay".showInMenuBarIfPresent = 0;

          hitoolbox = {
            AppleDictationAutoEnable = 0;
          };

          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
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

        CustomUserPreferences = {
          "com.apple.Accessibility" = {
            KeyRepeatDelay = 0.5;
            KeyRepeatEnabled = 1;
            KeyRepeatInterval = 0.033;
            ReduceMotionEnabled = 1;
          };

          "cc.ffitch.shottr" = {
            KeyboardShortcuts_area = "{\\\"carbonModifiers\\\":768,\\\"carbonKeyCode\\\":21}";
            KeyboardShortcuts_fullscreen = "{\\\"carbonModifiers\\\":768,\\\"carbonKeyCode\\\":20}";
            KeyboardShortcuts_window = "{\\\"carbonModifiers\\\":768,\\\"carbonKeyCode\\\":23}";
            afterGrabCopy = 1;
            afterGrabSave = 1;
            afterGrabShow = 1;
            allowTelemetry = 0;
            alwaysOnTop = 1;
            areadCaptureMode = "preview";
            cmdQAction = "quit";
            colorFormat = "HEX";
            copyOnEsc = 1;
            saveOnEsc = 1;
            defaultFolder = "/Users/${username}/Downloads";
            downscaleOnSave = 0;
            expandableCanvas = 1;
            saveFormat = "PNG";
            windowShadow = "trimmed";
            showDockIcon = 1;
            showIntro = 0;
            showMenubarIcon = 1;
            thumbnailClosing = "auto";
            token = "";
          };

          "com.apple.TextEdit".RichText = 0;

          "com.bjango.istatmenus.menubar.7" = {
            License.License = "";
            Menu.Theme.Dark = "system";
            Menubar = {
              Global.ReducePadding = 0;
              Theme.Dark = "custom";
            };
            Sensors.Global.DetailLevel = 1;

            Combined.Menu.Items = [
              "cpu-uptime"
              "cpu-cpu"
              "memory-overview"
              "disks-physical"
              "network-bandwidth"
              "sensors-overview"
              "battery-combined"
              "battery-bluetooth"
            ];

            Profiles.Settings.default = {
              Battery.Menubar.Enabled = 0;
              CPU.Menubar.Enabled = 0;
              Disks.Menubar.Enabled = 0;
              Memory.Menubar.Enabled = 0;
              Network.Menubar.Enabled = 0;
              Sensors.Menubar.Enabled = 0;
              Combined.Menubar = {
                Enabled = 1;
                Items = [
                  {
                    source = 1;
                    subtype = 1;
                    type = 3;
                  }
                  {
                    source = 2;
                    type = 3;
                  }
                  {
                    source = 3;
                    type = 3;
                  }
                  {
                    source = 7;
                    subtype = 6;
                    type = 7;
                  }
                ];
              };
            };
          };

          "com.generalarcade.flycut" = {
            "ShortcutRecorder mainHotKey" = {
              keyCode = 9;
              modifierFlags = 1179648;
            };
            loadOnStartup = 1;
            stickyBezel = 1;
            store = {
              displayLen = 40;
              displayNum = 10;
              favoritesRememberNum = 40;
              syncSettingsViaICloud = 0;
            };
          };

          "com.pilotmoon.scroll-reverser" = {
            HideIcon = 1;
            InvertScrollingOn = 1;
            ReverseTrackpad = 0;
            ReverseX = 1;
          };

          "com.rogueamoeba.soundsource" = {
            dontAskLaunchAtLogin = 1;
            hasRemovedHideAtLogin = 1;
            keyboardVolume = 1;
          };

          "company.thebrowser.Browser" = {
            arcMaxAutoOptInEnabled = 0;
            arc_quitAlwaysKeepsWindows = 1;
            currentAppIconName = "candy";
            meetArcMaxBannerDismissed = 1;
          };

          "io.github.keycastr" = {
            "default.allKeys" = 1;
            "default.allModifierdKeys" = 0;
            "default.commandKeysOnly" = 0;
            "default.fadeDelay" = 2.94;
            "default.fontSize" = 72;
            "default.keysstrokeDelay" = 1;
            displayIcon = 1;
            "mouse.displayOption" = 1;
            selectedVisualizer = "Default";
            "svelte.displayAll" = 0;
          };

          "io.tailscale.ipn.macos" = {
            TailscaleStartOnLogin = 1;
          };

          "org.videolan.vlc" = {
            DisplayTimeAsTimeRemaining = "YES";
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

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 5;
      # ids.gids.nixbld = 30000;

      nixpkgs.hostPlatform = system;
    };

    homeManagerArgs = {
      inherit username hostname;
    };

    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});
  in {
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./home;
            extraSpecialArgs = homeManagerArgs;
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."${hostname}".pkgs;

    packages.aarch64-darwin.installBrew = installBrew;
    packages.aarch64-darwin.setHostname = setHostname {
      hostname = "${hostname}";
    };

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
  };
}
