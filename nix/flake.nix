{
  description = "Modular Nix configuration";

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
    
    # Helper function to create darwin configurations
    darwinModules = import ./darwin {
      inherit nix-darwin home-manager nixpkgs;
    };
    
    # Current machine configuration
    currentMachine = darwinModules.mkDarwin {
      hostname = "lux";
      system = "aarch64-darwin";
      username = "arinono";
      fullname = "Aurelien Arino";
      email = "dev@arino.io";
      extraModules = [
        ({ pkgs, ... }: {
          # Add git_worktree_clean to system packages
          environment.systemPackages = with pkgs; [
            inputs.git_worktree_clean.packages.${pkgs.system}.default
          ] ++ private_flakes.bins pkgs.system;
        })
      ];
    };

    forAllSystems = fn: nixpkgs.lib.genAttrs systems (system: fn {pkgs = import nixpkgs {inherit system;};});
  in {
    # Darwin configuration
    darwinConfigurations."lux" = currentMachine.darwinConfiguration;
    darwinPackages = currentMachine.darwinPackages;

    # Packages
    packages.aarch64-darwin.installBrew = 
      let pkgs = import nixpkgs { system = "aarch64-darwin"; }; in
      with pkgs;
        pkgs.writeShellApplication {
          name = "install-homebrew";
          runtimeInputs = [bash curl];

          text = ''
            bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          '';
        };
    
    packages.aarch64-darwin.setHostname = 
      let pkgs = import nixpkgs { system = "aarch64-darwin"; }; in
      pkgs.writeShellApplication {
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

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);
  };
}