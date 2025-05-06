# Modular Nix Configuration

This repository contains a modular Nix configuration for managing multiple machines across different platforms. It's structured to promote reusability and clean organization.

## Structure

```
.
├── darwin/                  # macOS (nix-darwin) specific configuration
│   ├── default.nix          # Main file with mkDarwin helper
│   ├── defaults/            # Original macOS defaults (keeping for reference)
│   └── modules/             # Modular components for macOS
│       ├── apps/            # User applications
│       ├── development/     # Development tools & configuration
│       └── system/          # Core system configuration
├── home/                    # Home-manager configuration
├── secrets/                 # Secret management files
└── flake.nix               # Main flake with machines definition
```

## Usage

### Creating a New Machine Configuration

To create a new machine configuration, use the `mkDarwin` helper function in your `flake.nix`:

```nix
let
  myMachine = darwinModules.mkDarwin {
    hostname = "machine-name";
    system = "aarch64-darwin";   # or "x86_64-darwin"
    username = "your-username";
    fullname = "Your Full Name";  # optional
    email = "your@email.com";     # optional
    # Add extra modules specific to this machine
    extraModules = [];
    # Add extra home-manager modules specific to this machine
    extraHomeModules = [];
  };
in {
  darwinConfigurations."machine-name" = myMachine.darwinConfiguration;
}
```

### Modules

The configuration is organized into modules:

1. **System**: Core system settings, defaults, and Nix configuration
2. **Development**: Development tools and services
3. **Apps**: User applications and their defaults

## Customization

### Adding New Modules

To add a new module, create a new directory under the appropriate category:

```
mkdir -p darwin/modules/apps/new-module
```

Create a `default.nix` file in this directory and import it from the parent module.

### Overriding Existing Modules

You can override existing modules by providing your own version in `extraModules` when calling `mkDarwin`.

### Sharing Configurations Between Machines

Common configurations are shared by default. Machine-specific configurations should be added via the `extraModules` parameter.

## Installation & Rebuilding

### First-time Installation

If installing on a new machine:

1. Install Nix:
```bash
sh <(curl -L https://nixos.org/nix/install)
```

2. Install Homebrew (optional - will be managed by nix-darwin afterward):
```bash
nix run .#installBrew
```

3. Install nix-darwin:
```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

4. Set hostname (optional):
```bash
nix run .#setHostname -- your-hostname
```

5. Build and activate your configuration:
```bash
darwin-rebuild switch --flake .
```

### Rebuilding Your System

To rebuild your system after making changes:

```bash
# From the repo root
darwin-rebuild switch --flake .
```