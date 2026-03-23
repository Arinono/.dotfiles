{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  wf-recorder,
  grim,
  slurp,
  hyprland,
  jq,
  wl-clipboard,
  hyprpicker,
  libnotify,
}: 
let
  src = fetchFromGitHub {
    owner = "alonso-herreros";
    repo = "hyprcap";
    rev = "v1.5.1";
    sha256 = "sha256-qTlv4hRy9CvB+ZkNxXuxtLjDHsjiyjjooUlDFxwqQOc=";
  };
in
stdenv.mkDerivation {
  pname = "hyprcap";
  version = "1.5.1";

  inherit src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp hyprcap $out/bin/hyprcap
    chmod +x $out/bin/hyprcap
  '';

  postFixup = ''
    wrapProgram $out/bin/hyprcap \
      --prefix PATH : ${lib.makeBinPath [
        wf-recorder
        grim
        slurp
        hyprland
        jq
        wl-clipboard
        hyprpicker
        libnotify
      ]}
  '';

  nativeBuildInputs = [makeWrapper];

  meta = with lib; {
    description = "HyprCap is a utility to easily capture screenshots and screen recordings on Hyprland";
    homepage = "https://github.com/alonso-herreros/hyprcap";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "hyprcap";
  };
}
