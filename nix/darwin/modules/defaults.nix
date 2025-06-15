{
  params,
  pkgs,
  secrets,
  ...
}: let
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
in {
  system.defaults = with defaults;
    {
      CustomSystemPreferences = with defaults;
        general.CustomSystemPreferences
        // global.CustomSystemPreferences
        // dock_finder.CustomSystemPreferences;

      CustomUserPreferences = with defaults;
        arc_browser.CustomUserPreferences
        // flycut.CustomUserPreferences
        // istat_menus.CustomUserPreferences
        // keycastr.CustomUserPreferences
        // scroll_reverser.CustomUserPreferences
        // shottr.CustomUserPreferences
        // soundsource.CustomUserPreferences
        // tailscale.CustomUserPreferences
        // vlc.CustomUserPreferences;
    }
    // general.base
    // global.base
    // dock_finder.base;
}
