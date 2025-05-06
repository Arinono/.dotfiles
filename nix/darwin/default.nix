{nixpkgs, ...}: let
  params = hostname: rec {
    inherit hostname;
    username = "arinono";
    home = "/Users/${username}";
    fullname = "Aurelien Arino";
    email = "dev@arino.io";
  };
  pkgs = system:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
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

  isDarwin = true;
  homeManagerArgs = {
    # NOTE: change isDarwin to use provided function value when setting
    # up the machines
    inherit isDarwin params secrets;
  };
in {
  mkDarwin = system: hostname: {
  };
}
