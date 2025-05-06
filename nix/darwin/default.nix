{
  nix-darwin,
  home-manager,
  nixpkgs,
  ...
}: {
  mkDarwin = {
    hostname,
    system ? "aarch64-darwin",
    username,
    home ? "/Users/${username}",
    fullname ? null,
    email ? null,
    extraModules ? [],
    extraHomeModules ? [],
    includeBaseModules ? true,
  }: let
    isDarwin = true;
    params = {
      inherit username hostname home;
      fullname = if fullname != null then fullname else username;
      email = if email != null then email else "";
    };

    secrets = import ../secrets { inherit params; };

    homeManagerArgs = {
      inherit isDarwin params secrets;
    };

    # Base modules for darwin
    baseModules = [
      ./modules/system
    ] ++ (if includeBaseModules then [
      ./modules/development
      ./modules/apps
    ] else []);

    # Create the darwin configuration
    darwinConfig = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = baseModules ++ extraModules ++ [
        {
          nixpkgs.hostPlatform = system;
          nixpkgs.config.allowUnfree = true;

          users.users.${username} = {
            home = params.home;
            name = username;
          };

          system.stateVersion = 5;
        }
        
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = { ... }: {
              imports = [
                ../home
              ] ++ extraHomeModules;
            };
            extraSpecialArgs = homeManagerArgs;
          };
        }
      ];
    };
  in {
    inherit params secrets;
    darwinConfiguration = darwinConfig;
    darwinPackages = darwinConfig.pkgs;
  };
}