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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple_http_server = {
      url = "github:arinono/simple-http-server";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    private_flakes = {
      url = "git+ssh://git@github.com/arinono/private-flakes.git";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    nix-darwin,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    tools = import ./tools.nix inputs;
    inherit (tools) mkDarwin mkNixos;

    systems = ["aarch64-darwin" "x86_64-linux"];
    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});

    aarch64DarwinPkgs = import nixpkgs {
      system = "aarch64-darwin";
    };
    darwinTools = import ./darwin/tools.nix {pkgs = aarch64DarwinPkgs;};

    mkMerge = inputs.nixpkgs.lib.lists.foldl' (
      a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
    ) {};
  in
    mkMerge [
      (mkDarwin {
        hostname = "lux";
        system = "aarch64-darwin";
        nixpkgsVersion = nixpkgs;
        extraModules = [];
        extraHomeManagerModules = [
          ./darwin/modules/home/ghostty.nix
        ];
      })
      (mkNixos {
        hostname = "viktor";
        system = "x86_64-linux";
        nixpkgsVersion = nixpkgs;
        extraModules = [
          ./modules/tailscale.nix
          ./modules/hyprland.nix
          ./modules/steam.nix
        ];
        extraHomeManagerModules = [
          ./modules/home/modules/hyprland/default.nix
          ./modules/home/modules/ghostty.nix
        ];
      })
      {
        packages.aarch64-darwin.installBrew = darwinTools.installBrew;
        packages.aarch64-darwin.setHostname = darwinTools.setHostname;
        formatter = forAllSystems ({pkgs}: pkgs.alejandra);
      }
    ];
}
