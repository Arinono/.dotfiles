{username, ...}: let
  installFont = name: path: ''
    echo "Installing font ${name}"
    cp ${path}/* /Users/${username}/Library/Fonts/
  '';
in {
  system.activationScripts.fonts.text = ''
    ${installFont "aquatico" ../../../fonts/aquatico}
    ${installFont "SF Pro" ../../../fonts/SF_Pro}
    ${installFont "chinacat" ../../../fonts/chinacat}
    ${installFont "dank mono" ../../../fonts/dank_mono}
    ${installFont "droid sans mono for powerline" ../../../fonts/droid_sans_mono_for_powerline}
    ${installFont "manrope" ../../../fonts/manrope}
  '';
}
