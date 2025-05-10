{
  lib,
  stdenv,
  undmg,
}:
stdenv.mkDerivation {
  pname = "proton-vpn";
  version = "4.8.0";

  src = builtins.fetchurl {
    url = "https://vpn.protondownload.com/download/macos/4.8.0/ProtonVPN_mac_v4.8.0.dmg";
    sha256 = "101b6gbfa18fxf1g5w3c01xkqzqjjwz670yqms232h5rxjq7jw2i";
  };

  buildInputs = [undmg];
  sourceRoot = ".";
  phases = ["unpackPhase" "installPhase"];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications/
  '';

  meta = with lib; {
    description = "Proton VPN for macos";
    homepage = "https://protonvpn.com/download-macos";
    platforms = platforms.darwin;
  };
}
