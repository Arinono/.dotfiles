# Agent Guide for Nix Configuration

This document provides guidance for AI agents working on the Nix/NixOS configuration.

## Project Structure

```
~/.dotfiles/nix/
├── flake.nix                 # Main flake entry point
├── flake.lock                # Lock file for flake inputs
├── tools.nix                 # Helper functions for building configs
├── machines/                 # Per-machine NixOS configurations
│   ├── viktor/              # Laptop configuration
│   └── urgot/               # Desktop configuration
├── modules/                  # Shared NixOS and Home Manager modules
│   ├── hyprland.nix         # Hyprland window manager setup
│   ├── packages.nix         # Package collections
│   └── home/modules/        # Home Manager modules
│       ├── hyprland/        # Hyprland-specific home config
│       ├── zsh/             # Zsh configuration
│       └── ...
└── pkgs/                     # Custom packages
    └── hyprcap/             # Example: custom package definition
```

## Testing NixOS Configurations

### Dry Run (Check for Errors)

Test if the configuration evaluates without building:

```bash
cd ~/.dotfiles/nix
nix build .#nixosConfigurations.viktor.config.system.build.toplevel --dry-run
```

### Build Configuration

Build the configuration without activating it:

```bash
cd ~/.dotfiles/nix
nix build .#nixosConfigurations.viktor.config.system.build.toplevel
```

### Test Configuration (Requires sudo for activation)

Test the configuration (builds and activates temporarily):

```bash
# Note: This requires interactive authentication for activation
nixos-rebuild test --flake ~/.dotfiles/nix#viktor

# Or for urgot:
nixos-rebuild test --flake ~/.dotfiles/nix#urgot
```

## Important Notes

### Git Tracking

Nix flakes only include files tracked by git. **Always add new files to git** before building:

```bash
cd ~/.dotfiles
git add nix/path/to/new/file.nix
```

### Getting Package Hashes

When creating a new package with `fetchFromGitHub` or similar:

1. Use `lib.fakeSha256` as a placeholder
2. Try to build - it will fail with the correct hash
3. Copy the "got" hash from the error message
4. Update the file with the correct hash
5. Re-add to git and rebuild

Example error showing the correct hash:
```
error: hash mismatch in fixed-output derivation:
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-qTlv4hRy9CvB+ZkNxXuxtLjDHsjiyjjooUlDFxwqQOc=
```

### Available Configurations

- `viktor`: Laptop (x86_64-linux)
- `urgot`: Desktop (x86_64-linux)
- `lux`: macOS (aarch64-darwin)

### Creating Custom Packages

1. Create a new directory under `nix/pkgs/<pkgname>/`
2. Create `default.nix` with the package definition
3. Reference it using `pkgs.callPackage`:
   ```nix
   hyprcap = pkgs.callPackage ../pkgs/hyprcap {};
   ```
4. Add the new file to git before building

### Dependencies

All Hyprland-related packages should be defined in `nix/modules/hyprland.nix` so they're shared across machines. Machine-specific packages go in the respective `machines/<hostname>/default.nix`.

## Common Patterns

### Adding a Package to System Environment

```nix
environment.systemPackages = with pkgs; [
  package-name
];
```

### Creating a Wrapped Script

```nix
{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "script-name";
  runtimeInputs = [ pkgs.dependency1 pkgs.dependency2 ];
  text = ''
    # script content
  '';
}
```

### Adding Hyprland Keybindings

Edit `nix/modules/home/modules/hyprland/hyprland.nix` in the `extraConfig` section:

```nix
bind = ALT SHIFT, 2, exec, command-here
```
