inputs: let
  mkParams = {
    hostname,
    isDarwin,
    system,
  }: rec {
    inherit hostname system isDarwin;
    username = "arinono";
    home =
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    fullname = "Aurelien Arino";
    email = "dev@arino.io";
  };

  mkHomeManager = params: extraModules: let
    secrets = import ./modules/secrets {inherit params;};

    homeManagerArgs = {
      inherit params secrets;
      isDarwin = false;
    };
  in {
    home-manager = {
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${params.username}.imports =
        [
          ./modules/home
        ]
        ++ extraModules;
      extraSpecialArgs = homeManagerArgs;
    };
  };
in {
  mkDarwin = {
    hostname,
    system,
    nixpkgsVersion,
    extraModules,
    extraHomeManagerModules,
    ...
  }: let
    pkgs = import nixpkgsVersion {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    params = mkParams {
      inherit hostname system;
      isDarwin = true;
    };

    secrets = import ./modules/secrets {inherit params;};

    fonts = import ./darwin/modules/fonts.nix {
      inherit pkgs;
      username = params.username;
    };
    firewall = import ./darwin/modules/firewall.nix {};
    defaults = import ./darwin/modules/defaults.nix {
      inherit pkgs params secrets;
    };

    packages = import ./modules/packages.nix {inherit inputs pkgs params;};

    configuration = {
      pkgs,
      lib,
      config,
      ...
    }: {
      users.users.arinono = {
        home = params.home;
        name = params.username;
      };

      imports = [
        ./darwin/services/aerospace.nix
        ./darwin/modules/homebrew.nix
        ./darwin/modules/macos-applications.nix

        ./modules/nix.nix

        fonts
        firewall
        defaults
      ];

      environment.systemPackages = with packages;
        base
        ++ darwin
        ++ dev;
      # ++ private_flakes.bins system;

      system.primaryUser = params.username;

      ids.gids.nixbld = 350;
      system.stateVersion = 5;
      nixpkgs.hostPlatform = system;
    };
  in {
    darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
      modules =
        [
          configuration
          inputs.home-manager.darwinModules.home-manager
          ./machines/${hostname}/default.nix
          (mkHomeManager params ([] ++ extraHomeManagerModules))
        ]
        ++ extraModules;
    };
  };

  mkNixos = {
    hostname,
    system,
    nixpkgsVersion,
    extraModules,
    extraHomeManagerModules,
    ...
  }: let
    pkgs = import nixpkgsVersion {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    packages = import ./modules/packages.nix {inherit inputs pkgs params;};

    params = mkParams {
      inherit hostname system;
      isDarwin = false;
    };

    secrets = import ./modules/secrets {inherit params;};

    configuration = {
      users.defaultUserShell = pkgs.zsh;
      users.users.arinono = {
        home = params.home;
        name = params.username;
        extraGroups = ["docker"];
        shell = pkgs.zsh;
        useDefaultShell = true;
      };

      # managed by home-manager, but needed for default shell
      programs.zsh.enable = true;
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };

      imports = [
        ./modules/nix.nix
      ];

      environment.systemPackages = with packages;
        base
        ++ linux
        ++ dev;
      # ++ inputs.private_flakes.bins system;
    };
  in {
    nixosConfigurations."${hostname}" = nixpkgsVersion.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs secrets params;};
      modules =
        [
          configuration
          inputs.home-manager.nixosModules.home-manager
          ./machines/${hostname}/default.nix
          (mkHomeManager params ([] ++ extraHomeManagerModules))
        ]
        ++ extraModules;
    };
  };
}
