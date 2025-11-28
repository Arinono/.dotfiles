{
  params,
  pkgs,
  secrets,
  ...
}: let
  defaults = {
    general = import ../defaults/general.nix {inherit params;};
    global = import ../defaults/global.nix {};
    dock_finder = import ../defaults/dock_finder.nix {inherit pkgs params;};
    shottr = import ../defaults/shottr.nix {inherit params secrets;};
    istat_menus = import ../defaults/istat_menus.nix {inherit secrets;};
    flycut = import ../defaults/flycut.nix {};
    scroll_reverser = import ../defaults/scroll_reverser.nix {};
    soundsource = import ../defaults/soundsource.nix {inherit secrets;};
    keycastr = import ../defaults/keycastr.nix {};
    tailscale = import ../defaults/tailscale.nix {};
    vlc = import ../defaults/vlc.nix {};
  };
in {
  system.defaults = with defaults;
    {
      CustomSystemPreferences = with defaults;
        general.CustomSystemPreferences
        // global.CustomSystemPreferences
        // dock_finder.CustomSystemPreferences;

      CustomUserPreferences = with defaults;
        flycut.CustomUserPreferences
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
