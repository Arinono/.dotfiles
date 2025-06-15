{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [];

    casks = [
      "alfred"
      "balenaetcher"
      "calibre"
      "cameracontroller"
      "crystalfetch"
      "discord"
      "docker"
      "flycut"
      "font-meslo-lg-nerd-font"
      "ghostty"
      "istat-menus"
      "scroll-reverser"
      "shottr"
      "signal"
      "soundsource"
      "visual-studio-code@insiders"
      "vlc"
    ];

    brews = [];

    masApps = {
      Tailscale = 1475387142;
      Wireguard = 1451685025;
      Numbers = 409203825;
    };
  };
}
