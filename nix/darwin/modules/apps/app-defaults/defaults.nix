{
  pkgs,
  params,
  secrets,
  ...
}: let
  # Import app defaults
  arc_browser = import ../../../defaults/arc_browser.nix {};
  flycut = import ../../../defaults/flycut.nix {};
  istat_menus = import ../../../defaults/istat_menus.nix { inherit secrets; };
  keycastr = import ../../../defaults/keycastr.nix {};
  scroll_reverser = import ../../../defaults/scroll_reverser.nix {};
  shottr = import ../../../defaults/shottr.nix { inherit params secrets; };
  soundsource = import ../../../defaults/soundsource.nix { inherit secrets; };
  tailscale = import ../../../defaults/tailscale.nix {};
  vlc = import ../../../defaults/vlc.nix {};
in {
  system.defaults = {
    CustomUserPreferences = with pkgs.lib; 
      arc_browser.CustomUserPreferences
      // flycut.CustomUserPreferences
      // istat_menus.CustomUserPreferences
      // keycastr.CustomUserPreferences
      // scroll_reverser.CustomUserPreferences
      // shottr.CustomUserPreferences
      // soundsource.CustomUserPreferences
      // tailscale.CustomUserPreferences
      // vlc.CustomUserPreferences;
  };
}