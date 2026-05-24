{
  params,
  pkgs,
  secrets,
  ...
}: let
  defaults = {
    dock_finder = import ../defaults/dock_finder.nix {inherit pkgs params;};
    general = import ../defaults/general.nix {inherit params;};
    global = import ../defaults/global.nix {};
    istat_menus = import ../defaults/istat_menus.nix {inherit secrets;};
    keycastr = import ../defaults/keycastr.nix {};
    scroll_reverser = import ../defaults/scroll_reverser.nix {};
    shottr = import ../defaults/shottr.nix {inherit params secrets;};
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
        vlc.CustomUserPreferences
        // istat_menus.CustomUserPreferences
        // keycastr.CustomUserPreferences
        // scroll_reverser.CustomUserPreferences
        // shottr.CustomUserPreferences
        // tailscale.CustomUserPreferences;
    }
    // general.base
    // global.base
    // dock_finder.base;
}
